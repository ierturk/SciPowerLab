// StarGate-TR - Copyright 2011
// http://www.stargate-tr.com
// ierturk@stargate-tr.com

function [x, y, typ] = xcpl_PSDINV(job, arg1, arg2)

x = []; y = []; typ = [];

//disp(job)

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
                                          'Set PSDINV Generator Parameters',..
                                          ['X0'],..
                                          list('vec', 2),..
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
      X0 = [0; 0]
      
      model = scicos_model()
      model.sim = list('xcpl_PSDINV', 4)
      model.in = [4]
      model.out = [2]
      model.evtin = [1]
      model.state = []
      model.dstate = [X0]
      model.blocktype = 'c'
      model.dep_ut = [%t %t]

      exprs = strcat(string(X0'), ' ')
      gr_i = ['x=orig(1), y=orig(2), w=sz(1), h=sz(2)';
      'txt=[''PSEUDO'';''INVERTER'']';
      'xstringb(x + 0.25*w, y + 0.20*h, txt, 0.50*w, 0.60*h, ''fill'')';
      'txt=[''t_abc'';'''';''Vdc'']';
      'xstringb(x + 0.02*w, y + 0.08*h, txt, 0.25*w, 0.80*h, ''fill'')';
      'txt=[''Vd'';'''';''Vq'']';
      'xstringb(x+0.73*w, y+0.08*h, txt, 0.25*w, 0.80*h, ''fill'')';
      ]
      x = standard_define([4 2], model, exprs, gr_i)

  end

endfunction
