// StarGate Inc - Copyright 2014
// http://www.stargate-tr.com
// ierturk@ieee.org

mode(-1);
lines(0);
//=============================================================================
function main_builder()
	TOOLBOX_NAME  = "stargate_powerlab";
	TOOLBOX_TITLE = "StarGate - Xcos Module for Electrical Machines and Power Electronics";
	toolbox_dir   = get_absolute_file_path("builder.sce");

	// Check Scilab's version
	try
		v = getversion("scilab");
	catch
		error(gettext("Scilab 5.4 or more is required."));
	end

	if or(v(1:2) < [5 4]) then
		error(gettext('Scilab 5.4 or more is required.'));
	end

	// Check modules_manager module availability
	// ========================================================================
	if ~isdef('tbx_build_loader') then
		error(msprintf(gettext('%s module not installed."), 'modules_manager'));
	end
	tbx_builder_macros(toolbox_dir);
	tbx_builder_src(toolbox_dir);
	//tbx_builder_gateway(toolbox_dir);
	tbx_builder_macros(toolbox_dir);
	tbx_build_cleaner(TOOLBOX_NAME, toolbox_dir);
	tbx_build_loader(TOOLBOX_NAME, toolbox_dir);
	tbx_builder_help(toolbox_dir);
endfunction
//=============================================================================
main_builder();
clear main_builder;
//=============================================================================
