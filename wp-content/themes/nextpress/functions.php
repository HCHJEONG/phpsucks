<?php
/**
 * NextPress theme setup.
 *
 * @package NextPress
 */

if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

add_action(
	'after_setup_theme',
	function () {
		add_theme_support( 'title-tag' );
		add_theme_support( 'post-thumbnails' );
		add_theme_support( 'html5', array( 'search-form', 'comment-form', 'comment-list', 'gallery', 'caption', 'style', 'script' ) );
	}
);

add_action(
	'wp_enqueue_scripts',
	function () {
		wp_enqueue_style( 'nextpress-style', get_stylesheet_uri(), array(), wp_get_theme()->get( 'Version' ) );
	}
);

add_action(
	'wp_head',
	function () {
		$favicon_url = get_theme_file_uri( 'assets/favicon.svg' );
		echo '<link rel="icon" href="' . esc_url( $favicon_url ) . '" type="image/svg+xml">' . "\n";
	}
);
