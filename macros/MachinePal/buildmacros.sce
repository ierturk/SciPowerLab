//=============================================================================
// Copyright (C) StarGate Inc - 2014
//=============================================================================
function buildmacros()
	macros_path = get_absolute_file_path("buildmacros.sce");
	tbx_build_macros("LibMachinePal", macros_path);
endfunction
//=============================================================================
buildmacros();
clear buildmacros;
//=============================================================================
