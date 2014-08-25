// StarGate-TR - Copyright 2011
// http://www.stargate-tr.com
// ierturk@stargate-tr.com

function subdemolist = demo_gateway()

  demopath = get_absolute_file_path("powerlab.dem.gateway.sce");
  subdemolist = ['PMSM FOC', 'demPMSM.dem.sce']; // add demos here
  subdemolist(:,2) = demopath + subdemolist(:,2);
 
endfunction

subdemolist = demo_gateway();
clear demo_gateway; // remove demo_gateway on stack
