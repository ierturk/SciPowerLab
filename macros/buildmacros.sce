// ErturkMe - Copyright 2011 - 2022
// http://erturk.me
// ierturk@ieee.org
// See license.txt

function buildmacros()
	curdir = get_absolute_file_path("buildmacros.sce");

	macrosdirs = [..
					"MachinePal",..
					"ControlPal"..
				];


	for i=1:size(macrosdirs,"*") do
		exec(curdir + "/" + macrosdirs(i) + "/buildmacros.sce");
	end
endfunction

buildmacros();
clear buildmacros; // remove buildmacros on stack
