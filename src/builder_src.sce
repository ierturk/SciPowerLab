// ErturkMe - Copyright 2011 - 2024
// http://erturk.me
// me@erturk.me
// See license.txt

function builder_src()
  src_path = get_absolute_file_path("builder_src.sce");
  tbx_builder_src_lang("c", src_path);
endfunction

builder_src();
clear builder_src; // remove builder_src on stack


