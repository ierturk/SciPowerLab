// ErturkMe - Copyright 2011 - 2024
// http://erturk.me
// me@erturk.me
// See license.txt

function cleanmacros()
	curdir = get_absolute_file_path("cleanmacros.sce");
	macrosdirs = [..
					"MachinePal",..
					"ControlPal"..
				];
	for i=1:size(macrosdirs,"*") do
		exec(curdir+"/"+macrosdirs(i)+"/cleanmacros.sce");
	end
endfunction

cleanmacros();
clear cleanmacros; // remove buildmacros on stack
