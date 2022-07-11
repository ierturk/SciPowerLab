// ErturkMe - Copyright 2011 - 2022
// http://erturk.me
// ierturk@ieee.org
// See license.txt

function [x, y, typ] = xcpl_SVPWM(job, arg1, arg2)

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
        [ok, X0, exprs] = getvalue(..
                                          'Set SVPWM Generator Parameters',..
                                          ['X0'],..
                                          list('vec', 3),..
                                          exprs)

        if ~ok then break, end
          
        model.dstate = [X0]
        model.rpar = []
        graphics.exprs = exprs
        x.graphics = graphics
        x.model = model
        break
      end

    case 'define' then
      X0 = [0; 0; 0]
      
      model = scicos_model()
      model.sim = list('xcpl_SVPWM', 4)
      model.in = [3]
      model.out = [3]
      model.evtin = [1]
      model.state = []
      model.dstate = [X0]
      model.blocktype = 'c'
      model.dep_ut = [%t %t]

      exprs = strcat(string(X0'), ' ')
      gr_i = ['x=orig(1), y=orig(2), w=sz(1), h=sz(2)';
      'txt=[''SVPWM'';''Generator'']';
      'xstringb(x + 0.25*w, y + 0.20*h, txt, 0.50*w, 0.60*h, ''fill'')';
      'txt=[''V_dq'';'''';''Vdc'']';
      'xstringb(x + 0.02*w, y + 0.08*h, txt, 0.25*w, 0.80*h, ''fill'')';
      'txt=[''ta'';''tb'';''tc'']';
      'xstringb(x+0.73*w, y+0.08*h, txt, 0.25*w, 0.80*h, ''fill'')';
      ]
      x = standard_define([4 2], model, exprs, gr_i)

  end

endfunction
