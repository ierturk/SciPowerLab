// ErturkMe - Copyright 2014 - 2022
// http://erturk.me
// ierturk@ieee.org
// See license.txt

mode(-1);
lines(0);

function main_builder()

	TOOLBOX_NAME  = "erturkme_powerlab";
	TOOLBOX_TITLE = "ErturkMe - Xcos Module for Electrical Machines and Power Electronics";
    toolbox_dir   = get_absolute_file_path("builder.sce");

    // Check Scilab's version
    // =============================================================================

    // check minimal version (xcosPal required)
    if ~isdef("xcosPal") then
        // and xcos features required
        error(gettext("Scilab 5.3.2 or more is required."));
    end

    // Check modules_manager module availability
    // =============================================================================

    if ~isdef("tbx_build_loader") then
        error(msprintf(gettext("%s module not installed."), "modules_manager"));
    end


    if ~isdir(toolbox_dir+filesep()+"images"+filesep()+"h5")
        [status, msg] = mkdir(toolbox_dir+filesep()+"images"+filesep()+"h5");
        if and(status <> [1 2])
            error(msg);
        end
    end

    // Action
    // =============================================================================

    tbx_builder_macros(toolbox_dir);
    tbx_builder_src(toolbox_dir);
    tbx_builder_gateway(toolbox_dir);
    tbx_builder_help(toolbox_dir);
    tbx_build_loader(toolbox_dir);
    tbx_build_cleaner(toolbox_dir);
endfunction

if with_module("xcos") then
    main_builder();
    clear main_builder; // remove main_builder on stack
end
