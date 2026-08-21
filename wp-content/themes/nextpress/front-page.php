<?php
/**
 * Static service homepage.
 *
 * @package NextPress
 */

?><!doctype html>
<html <?php language_attributes(); ?>>
<head>
	<meta charset="<?php bloginfo( 'charset' ); ?>">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<?php wp_head(); ?>
</head>
<body <?php body_class(); ?>>
<?php wp_body_open(); ?>

<header class="np-header">
	<div class="np-shell np-nav">
		<a class="np-brand" href="<?php echo esc_url( home_url( '/' ) ); ?>" aria-label="NextPress home">
			NextPress
		</a>
		<nav class="np-menu" aria-label="Primary">
			<a href="#principles">원칙</a>
			<a href="#process">절차</a>
			<a href="#faq">FAQ</a>
			<a class="np-button secondary" href="#contact">상담하기</a>
		</nav>
	</div>
</header>

<main>
	<section class="np-hero">
		<div class="np-shell np-hero-grid">
			<div>
				<p class="np-kicker">WordPress to Next.js</p>
				<h1>WordPress의 SEO는 그대로, 프론트엔드는 Next.js로 더 빠르게.</h1>
				<p class="np-lead">기존 MySQL 데이터베이스와 URL 구조를 존중하면서 검색 노출 손실을 줄이는 마이그레이션을 설계합니다. 사이트 콘텐츠를 새 post 데이터로 쌓아 보여주는 방식보다, 보존과 전환의 경계를 명확히 잡습니다.</p>
				<div class="np-actions">
					<a class="np-button" href="#contact">마이그레이션 상담하기</a>
					<a class="np-button secondary" href="#principles">SEO 유지 방식 보기</a>
				</div>
				<div class="np-proof" aria-label="Migration priorities">
					<div>URL 보존</div>
					<div>MySQL 유지</div>
					<div>Next.js 전환</div>
				</div>
			</div>
			<div class="np-map" aria-label="Migration architecture diagram">
				<div class="np-map-row">
					<div class="np-node"><strong>WordPress</strong><small>기존 관리자, 글, 미디어, 메타데이터</small></div>
					<div class="np-arrow">→</div>
					<div class="np-node"><strong>MySQL</strong><small>보존 대상 데이터 원천</small></div>
				</div>
				<div class="np-map-row">
					<div class="np-node"><strong>Migration Layer</strong><small>slug, taxonomy, SEO field mapping</small></div>
					<div class="np-arrow">→</div>
					<div class="np-node"><strong>Next.js</strong><small>빠른 렌더링과 안정적인 배포</small></div>
				</div>
			</div>
		</div>
	</section>

	<section id="principles" class="np-section">
		<div class="np-shell">
			<div class="np-section-head">
				<h2>검색 자산을 먼저 지키는 전환 원칙</h2>
				<p>마이그레이션의 목표는 새 프레임워크 과시가 아니라, 이미 쌓인 검색 신뢰와 운영 데이터를 훼손하지 않는 것입니다.</p>
			</div>
			<div class="np-grid-3">
				<article class="np-card">
					<h3>URL과 slug 보존</h3>
					<p>기존 permalink, category, tag, archive 흐름을 분석하고 불가피한 변경은 301 redirect로 연결합니다.</p>
				</article>
				<article class="np-card">
					<h3>SEO 메타데이터 이관</h3>
					<p>title, description, canonical, Open Graph, sitemap, robots 정책을 전환 전후로 비교합니다.</p>
				</article>
				<article class="np-card">
					<h3>MySQL 유지 설계</h3>
					<p>기존 WordPress 데이터를 무리하게 재작성하지 않고 필요한 범위에서 Next.js와 연결합니다.</p>
				</article>
			</div>
		</div>
	</section>

	<section id="process" class="np-section soft">
		<div class="np-shell">
			<div class="np-section-head">
				<h2>진단부터 배포까지 작게 검증합니다</h2>
				<p>검색 유입이 있는 사이트일수록 한 번에 갈아엎기보다 데이터, URL, 렌더링, 배포를 나누어 확인해야 합니다.</p>
			</div>
			<div class="np-process">
				<div class="np-step"><strong>1. 진단</strong><span class="np-muted">테마, 플러그인, URL, SEO 상태 확인</span></div>
				<div class="np-step"><strong>2. 설계</strong><span class="np-muted">데이터 접근과 렌더링 방식 결정</span></div>
				<div class="np-step"><strong>3. 구현</strong><span class="np-muted">Next.js 화면과 데이터 매핑 구축</span></div>
				<div class="np-step"><strong>4. 검수</strong><span class="np-muted">메타태그, 링크, redirect, 성능 점검</span></div>
				<div class="np-step"><strong>5. 배포</strong><span class="np-muted">점진 전환 또는 전체 전환</span></div>
			</div>
		</div>
	</section>

	<section class="np-section">
		<div class="np-shell">
			<div class="np-section-head">
				<h2>이런 사이트에 맞습니다</h2>
				<p>콘텐츠가 이미 검색되고 있고, WordPress 관리 경험이나 데이터 구조를 한 번에 버리기 어려운 경우에 특히 적합합니다.</p>
			</div>
			<div class="np-grid-3">
				<article class="np-card">
					<h3>오래 운영한 블로그</h3>
					<p>게시글 수가 많고 기존 검색 유입이 중요한 콘텐츠 사이트.</p>
				</article>
				<article class="np-card">
					<h3>지역 비즈니스 홈페이지</h3>
					<p>병원, 법률, 학원, 전문 서비스처럼 검색 신뢰가 매출과 이어지는 사이트.</p>
				</article>
				<article class="np-card">
					<h3>커스텀 WordPress</h3>
					<p>커스텀 포스트 타입, 메타 필드, 분류 체계를 정리하며 전환해야 하는 사이트.</p>
				</article>
			</div>
		</div>
	</section>

	<section id="faq" class="np-section soft">
		<div class="np-shell">
			<div class="np-section-head">
				<h2>자주 묻는 질문</h2>
			</div>
			<div class="np-grid-3">
				<article class="np-card">
					<h3>WordPress 관리자는 계속 쓸 수 있나요?</h3>
					<p>사이트 상태에 따라 가능합니다. WordPress를 데이터 관리 도구로 남기고 Next.js가 화면을 담당하는 구조를 검토합니다.</p>
				</article>
				<article class="np-card">
					<h3>검색 순위가 떨어지지 않나요?</h3>
					<p>보장을 말하기보다 위험을 줄이는 작업을 합니다. URL, 메타, sitemap, redirect, 속도 지표를 전환 전후로 확인합니다.</p>
				</article>
				<article class="np-card">
					<h3>이 홈페이지도 DB post로 운영하나요?</h3>
					<p>아닙니다. 이 서비스 홈페이지는 정적 구조를 우선하고, DB post 의존은 마이그레이션 대상 사이트에 한정해 다룹니다.</p>
				</article>
			</div>
		</div>
	</section>

	<section id="contact" class="np-section">
		<div class="np-shell">
			<div class="np-section-head">
				<h2>기존 사이트를 먼저 보고 판단합니다</h2>
				<p>현재 WordPress 주소, 주요 검색 유입 페이지, 유지해야 할 URL 정책을 기준으로 전환 범위를 제안합니다.</p>
			</div>
			<a class="np-button" href="mailto:hello@penvot.com">hello@penvot.com</a>
		</div>
	</section>
</main>

<footer class="np-footer">
	<div class="np-shell">
		<strong>NextPress</strong>
		<span> | 대표 정희찬 | 사업자등록번호 105-05-48527 | 서울특별시 종로구 율곡로2길 7, 304호 (03143) | 02-3210-3330</span>
	</div>
</footer>

<?php wp_footer(); ?>
</body>
</html>
