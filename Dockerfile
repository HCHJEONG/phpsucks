# FROM node:24 AS frontend

# WORKDIR /build

# COPY ./wp-content/themes/phpsucks/package*.json ./
# RUN npm ci

# COPY ./wp-content/themes/phpsucks/ ./
# RUN npm run build


FROM wordpress:7.0.2-php8.3-apache

COPY ./wp-content /var/www/html/wp-content

# COPY --from=frontend \
#     /build/dist \
#     /var/www/html/wp-content/themes/phpsucks/dist
