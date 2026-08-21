(function () {
	var revealItems = document.querySelectorAll( '.np-reveal, .np-card, .np-step, .np-proof div' );

	if ( ! revealItems.length ) {
		return;
	}

	revealItems.forEach( function (item, index) {
		item.classList.add( 'np-reveal-ready' );
		item.style.setProperty( '--np-reveal-delay', Math.min( index % 5, 4 ) * 90 + 'ms' );
	} );

	if ( ! ( 'IntersectionObserver' in window ) ) {
		revealItems.forEach( function (item) {
			item.classList.add( 'is-visible' );
		} );
		return;
	}

	var observer = new IntersectionObserver(
		function (entries) {
			entries.forEach( function (entry) {
				if ( entry.isIntersecting ) {
					entry.target.classList.add( 'is-visible' );
					observer.unobserve( entry.target );
				}
			} );
		},
		{
			rootMargin: '0px 0px -12% 0px',
			threshold: 0.16
		}
	);

	revealItems.forEach( function (item) {
		observer.observe( item );
	} );
}());
