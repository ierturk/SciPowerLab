// ErturkMe - Copyright 2011 - 2024
// http://erturk.me
// me@erturk.me
// See license.txt

function buildmacros()
	macros_path = get_absolute_file_path("buildmacros.sce");
	tbx_build_macros("LibControlPal", macros_path);
endfunction

buildmacros();
clear buildmacros;
