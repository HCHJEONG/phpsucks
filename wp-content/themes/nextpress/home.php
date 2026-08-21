<?php
/**
 * Disable the posts index entry point for the service homepage.
 *
 * @package NextPress
 */

wp_safe_redirect( home_url( '/' ), 301 );
exit;
