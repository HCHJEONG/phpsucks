#!/usr/bin/env bash
set -euo pipefail

IMAGE_REPOSITORY="phpsucks"
IMAGE_VERSION="aws$(date +'%Y%m%d%H%M%S')"
IMAGE_TAG="${IMAGE_REPOSITORY}:${IMAGE_VERSION}"
PROJECT_NAME="phpsucks"
HOST_PORT="${HOST_PORT:-8090}"
REPO_URL="${REPO_URL:-git@github.com:HCHJEONG/phpsucks.git}"
DEPLOY_BRANCH="${DEPLOY_BRANCH:-main}"
DEPLOY_REMOTE_ROOT="${DEPLOY_REMOTE_ROOT:-$HOME/deploy-remote-repo}"
CLEAN_REPO_DIR="${DEPLOY_REMOTE_ROOT}/${PROJECT_NAME}"
COMPOSE_SOURCE_FILE="${CLEAN_REPO_DIR}/.fordeploy/compose.aws-demo.yaml"
BASTION_HOST="${BASTION_HOST:-ubuntu@43.202.136.180}"
PRIVATE_HOST="${PRIVATE_HOST:-ubuntu@172.31.76.194}"
LOCAL_SSH_KEY="${LOCAL_SSH_KEY:-$HOME/.ssh/penvotkeypair1.pem}"
BASTION_SSH_KEY="${BASTION_SSH_KEY:-/home/ubuntu/.ssh/penvotkeypair1.pem}"
REMOTE_DIR="/home/ubuntu"
APP_DIR="/home/ubuntu/phpsucks"
ENV_FILE="${APP_DIR}/.env"
COMPOSE_FILE="${APP_DIR}/compose.aws-demo.yaml"

IMAGE_ARCHIVE_PATH="$(mktemp "${TMPDIR:-/tmp}/phpsucks-image.XXXXXX.tar")"
IMAGE_ARCHIVE_NAME="$(basename "${IMAGE_ARCHIVE_PATH}")"
COMPOSE_TRANSFER_NAME="${PROJECT_NAME}-${IMAGE_VERSION}.compose.yaml"

cleanup() {
  rm -f "${IMAGE_ARCHIVE_PATH}"
}
trap cleanup EXIT

test -f "${LOCAL_SSH_KEY}" || { echo "Missing local SSH key: ${LOCAL_SSH_KEY}"; exit 1; }

mkdir -p "${DEPLOY_REMOTE_ROOT}"
if [ ! -d "${CLEAN_REPO_DIR}/.git" ]; then
  git clone "${REPO_URL}" "${CLEAN_REPO_DIR}"
fi
git -C "${CLEAN_REPO_DIR}" fetch --prune origin "+refs/heads/${DEPLOY_BRANCH}:refs/remotes/origin/${DEPLOY_BRANCH}"
git -C "${CLEAN_REPO_DIR}" checkout -B "${DEPLOY_BRANCH}" "origin/${DEPLOY_BRANCH}"
git -C "${CLEAN_REPO_DIR}" reset --hard "origin/${DEPLOY_BRANCH}"
git -C "${CLEAN_REPO_DIR}" clean -fdx \
  -e .env \
  -e .env.* \
  -e wp-content/uploads \
  -e wp-content/cache

test -f "${COMPOSE_SOURCE_FILE}" || { echo "Missing compose file: ${COMPOSE_SOURCE_FILE}"; exit 1; }
docker build -t "${IMAGE_TAG}" "${CLEAN_REPO_DIR}"
docker save -o "${IMAGE_ARCHIVE_PATH}" "${IMAGE_TAG}"

scp -o StrictHostKeyChecking=accept-new -i "${LOCAL_SSH_KEY}" \
  "${IMAGE_ARCHIVE_PATH}" "${COMPOSE_SOURCE_FILE}" \
  "${BASTION_HOST}:${REMOTE_DIR}/"

ssh -o StrictHostKeyChecking=accept-new -i "${LOCAL_SSH_KEY}" "${BASTION_HOST}" \
  PRIVATE_HOST="${PRIVATE_HOST}" BASTION_SSH_KEY="${BASTION_SSH_KEY}" REMOTE_DIR="${REMOTE_DIR}" \
  IMAGE_ARCHIVE_NAME="${IMAGE_ARCHIVE_NAME}" COMPOSE_TRANSFER_NAME="${COMPOSE_TRANSFER_NAME}" IMAGE_REPOSITORY="${IMAGE_REPOSITORY}" \
  IMAGE_TAG="${IMAGE_TAG}" PROJECT_NAME="${PROJECT_NAME}" HOST_PORT="${HOST_PORT}" APP_DIR="${APP_DIR}" ENV_FILE="${ENV_FILE}" \
  COMPOSE_FILE="${COMPOSE_FILE}" bash -s <<'BASTION'
set -euo pipefail
test -f "${BASTION_SSH_KEY}" || { echo "Missing bastion SSH key: ${BASTION_SSH_KEY}"; exit 1; }
mv "${REMOTE_DIR}/compose.aws-demo.yaml" "${REMOTE_DIR}/${COMPOSE_TRANSFER_NAME}"
scp -o StrictHostKeyChecking=accept-new -i "${BASTION_SSH_KEY}" \
  "${REMOTE_DIR}/${IMAGE_ARCHIVE_NAME}" "${REMOTE_DIR}/${COMPOSE_TRANSFER_NAME}" \
  "${PRIVATE_HOST}:${REMOTE_DIR}/"
ssh -o StrictHostKeyChecking=accept-new -i "${BASTION_SSH_KEY}" "${PRIVATE_HOST}" \
  REMOTE_DIR="${REMOTE_DIR}" IMAGE_ARCHIVE_NAME="${IMAGE_ARCHIVE_NAME}" COMPOSE_TRANSFER_NAME="${COMPOSE_TRANSFER_NAME}" \
  IMAGE_REPOSITORY="${IMAGE_REPOSITORY}" IMAGE_TAG="${IMAGE_TAG}" PROJECT_NAME="${PROJECT_NAME}" HOST_PORT="${HOST_PORT}" \
  APP_DIR="${APP_DIR}" ENV_FILE="${ENV_FILE}" COMPOSE_FILE="${COMPOSE_FILE}" bash -s <<'PRIVATE'
set -euo pipefail

sudo install -d "${APP_DIR}"
test -f "${ENV_FILE}" || { echo "Missing env file: ${ENV_FILE}"; exit 1; }
sudo cp "${REMOTE_DIR}/${COMPOSE_TRANSFER_NAME}" "${COMPOSE_FILE}"
sudo docker load -i "${REMOTE_DIR}/${IMAGE_ARCHIVE_NAME}"

# The official WordPress image declares /var/www/html as a volume. Recreate only
# the wordpress container so that its anonymous html volume is refreshed from the
# newly loaded image, while named volumes such as mysql_data and uploads remain.
sudo env IMAGE_TAG="${IMAGE_TAG}" HOST_PORT="${HOST_PORT}" docker compose \
  --env-file "${ENV_FILE}" \
  -p "${PROJECT_NAME}" \
  -f "${COMPOSE_FILE}" \
  stop wordpress || true
sudo env IMAGE_TAG="${IMAGE_TAG}" HOST_PORT="${HOST_PORT}" docker compose \
  --env-file "${ENV_FILE}" \
  -p "${PROJECT_NAME}" \
  -f "${COMPOSE_FILE}" \
  rm --force --stop --volumes wordpress || true

sudo env IMAGE_TAG="${IMAGE_TAG}" HOST_PORT="${HOST_PORT}" docker compose \
  --env-file "${ENV_FILE}" \
  -p "${PROJECT_NAME}" \
  -f "${COMPOSE_FILE}" \
  up -d

for attempt in {1..30}; do
  if curl --fail --silent "http://127.0.0.1:${HOST_PORT}/" >/dev/null; then break; fi
  if [ "${attempt}" -eq 30 ]; then
    sudo env IMAGE_TAG="${IMAGE_TAG}" HOST_PORT="${HOST_PORT}" docker compose --env-file "${ENV_FILE}" -p "${PROJECT_NAME}" -f "${COMPOSE_FILE}" logs --tail 200
    exit 1
  fi
  sleep 2
done

CURRENT_IMAGE_ID="$(sudo docker image inspect --format '{{.Id}}' "${IMAGE_TAG}")"
while IFS=$'\t' read -r candidate_repository candidate_tag; do
  [ "${candidate_repository}" = "${IMAGE_REPOSITORY}" ] || continue
  [ "${candidate_tag}" != "<none>" ] || continue
  candidate_ref="${candidate_repository}:${candidate_tag}"
  candidate_image_id="$(sudo docker image inspect --format '{{.Id}}' "${candidate_ref}")"
  [ "${candidate_image_id}" != "${CURRENT_IMAGE_ID}" ] || continue
  sudo docker image rm "${candidate_ref}" || true
done < <(sudo docker image ls --format '{{.Repository}}\t{{.Tag}}')

sudo env IMAGE_TAG="${IMAGE_TAG}" HOST_PORT="${HOST_PORT}" docker compose \
  --env-file "${ENV_FILE}" \
  -p "${PROJECT_NAME}" \
  -f "${COMPOSE_FILE}" \
  ps
sudo rm -f "${REMOTE_DIR}/${IMAGE_ARCHIVE_NAME}" "${REMOTE_DIR}/${COMPOSE_TRANSFER_NAME}"
PRIVATE
rm -f "${REMOTE_DIR}/${IMAGE_ARCHIVE_NAME}" "${REMOTE_DIR}/${COMPOSE_TRANSFER_NAME}"
BASTION

echo "DEPLOY SUCCESS: ${IMAGE_TAG} on ${PRIVATE_HOST}:${HOST_PORT}"
