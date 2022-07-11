// ErturkMe - Copyright 2011 - 2022
// http://erturk.me
// ierturk@ieee.org
// See license.txt

function buildmacros()
	macros_path = get_absolute_file_path("buildmacros.sce");
	tbx_build_macros("LibControlPal", macros_path);
endfunction

buildmacros();
clear buildmacros;
