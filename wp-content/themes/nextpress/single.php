<?php
/**
 * Disable direct post entry points for the service homepage.
 *
 * @package NextPress
 */

wp_safe_redirect( home_url( '/' ), 301 );
exit;
