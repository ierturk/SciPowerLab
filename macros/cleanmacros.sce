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
