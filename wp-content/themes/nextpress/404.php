<?php
/**
 * Keep unknown routes on the static service homepage for now.
 *
 * @package NextPress
 */

status_header( 404 );
get_template_part( 'front-page' );
