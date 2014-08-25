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
