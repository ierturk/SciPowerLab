// StarGate-TR - Copyright 2011
// http://www.stargate-tr.com
// ierturk@stargate-tr.com

function builder_src()
  src_path = get_absolute_file_path("builder_src.sce");
  tbx_builder_src_lang("c", src_path);
endfunction

builder_src();
clear builder_src; // remove builder_src on stack


