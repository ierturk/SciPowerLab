// ErturkMe - Copyright 2011 - 2022
// http://erturk.me
// ierturk@ieee.org
// See license.txt

function cleanmacros()
	libpath = get_absolute_file_path('cleanmacros.sce');

	binfiles = ls(libpath+'/*.bin');
	for i = 1:size(binfiles,'*')
		mdelete(binfiles(i));
	end

	mdelete(libpath+'/names');
	mdelete(libpath+'/lib');

endfunction

cleanmacros();
clear cleanmacros;
