// ErturkMe - Copyright 2011 - 2022
// http://erturk.me
// ierturk@ieee.org
// See license.txt

function [x, y, typ] = xcpl_BLSC(job, arg1, arg2)

x = []; y = []; typ = [];

  select job
    case 'plot' then
      standard_draw(arg1)

    case 'getinputs' then
      [x, y, typ] = standard_inputs(arg1)

    case 'getoutputs' then
      [x, y, typ] = standard_outputs(arg1)

    case 'getorigin' then
      [x, y] = standard_origin(arg1)

    case 'set' then
      x = arg1;
      graphics = arg1.graphics;
      exprs = graphics.exprs
      model = arg1.model;
      
      while %t do
        [ok, Vdc, Kp, Ki, exprs] = getvalue(..
                                                  'Set Brushless DC Controller Parameters',..
                                                  ['DC Bus Voltage [V]';..
                                                  'Controller Proportional Constant';..
                                                  'Controller Integral Constant'],..
                                                  list('vec', 1, 'vec', 1, 'vec', 1),..
                                                  exprs)

        if ~ok then break, end
          
        model.rpar = [Vdc; Kp; Ki]
        graphics.exprs = exprs
        x.graphics = graphics
        x.model = model
        break
      end

    case 'define' then
      Vdc = 12.
      Kp = 0.8
      Ki = 30.
          
      model = scicos_model()
      model.sim = list('xcpl_BLSC', 4)
      model.evtin = [0]
      model.in = [7]
      model.out = [3]
      model.state = [0]
      model.dstate = []
      model.rpar = [Vdc; Kp; Ki]
      model.blocktype = 'c'
      model.dep_ut = [%f %t]
      
      exprs = string(model.rpar);
      gr_i = [
            'x=orig(1), y=orig(2), w=sz(1), h=sz(2)';
            'txt=[''BLDC Sensored'';''Controller'']';
            'xstringb(x + 0.25*w, y + 0.20*h, txt, 0.50*w, 0.60*h, ''fill'')';
            'txt=[''iabc'';''wr'';''theta'';''mode'';''w*'']';
            'xstringb(x + 0.02*w, y + 0.08*h, txt, 0.25*w, 0.80*h, ''fill'')';
            'txt=[''Va'';''Vb'';''Vc'']';
            'xstringb(x+0.73*w, y+0.08*h, txt, 0.25*w, 0.80*h, ''fill'')';]
      x = standard_define([4 2], model, exprs, gr_i)

  end

endfunction
