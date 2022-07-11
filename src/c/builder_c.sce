// ErturkMe - Copyright 2011 - 2022
// http://erturk.me
// ierturk@ieee.org
// See license.txt

// This macro compiles the files

function builder_c()
  src_c_path = get_absolute_file_path("builder_c.sce");

  CFLAGS = ilib_include_flag(src_c_path);
  LDFLAGS = "";
  if (getos()<>"Windows") then
    if ~isdir(SCI+"/../../share") then
      // Source version
      CFLAGS = CFLAGS + " -I" + SCI + "/modules/scicos_blocks/includes" ;
      CFLAGS = CFLAGS + " -I" + SCI + "/modules/scicos/includes" ;
    else
      // Release version
      CFLAGS = CFLAGS + " -I" + SCI + "/../../include/scilab/scicos_blocks";
      CFLAGS = CFLAGS + " -I" + SCI + "/../../include/scilab/scicos";
    end
  else
    CFLAGS = CFLAGS + " -I" + SCI + "/modules/scicos_blocks/includes";
    CFLAGS = CFLAGS + " -I" + SCI + "/modules/scicos/includes";

    // Getting symbols
    if findmsvccompiler() <> "unknown" & haveacompiler() then
      LDFLAGS = LDFLAGS + " """ + SCI + "/bin/scicos.lib""";
      LDFLAGS = LDFLAGS + " """ + SCI + "/bin/scicos_f.lib""";
      if win64() then
          LDFLAGS = LDFLAGS + " ""C:\Program Files\Microsoft SDKs\Windows\v7.1\Lib\x64\Kernel32.Lib"""
      end
    end
  end
  
    xcpl_names = ['xcpl_BLDC',..
                  'xcpl_BLSC',..
                  'xcpl_PMSM',..
                  'xcpl_PMSC',..
                  'xcpl_IMPU',..
                  'xcpl_SVPWM',..
                  'xcpl_PSDINV'..
                  ]
                
    xcpl_files = ['xcpl_BLDC_comp.c',..
                  'xcpl_BLSC_comp.c',..
                  'xcpl_PMSM_comp.c',..
                  'xcpl_PMSC_comp.c',..
                  'xcpl_IMPU_comp.c',..
                  'xcpl_SVPWM_comp.c',..
                  'xcpl_PSDINV_comp.c'..
                  ]

  tbx_build_src(xcpl_names,                           ..
                xcpl_files,                           ..
                "c",                                  ..
                src_c_path,                           ..
                "",                                   ..
                LDFLAGS,                              ..
                CFLAGS,                               ..
                "",                                   ..
                "",                                   ..
                "XCPL_tbx");
endfunction

builder_c();
clear builder_c xcpl_names xcpl_files; // remove builder_c on stack
