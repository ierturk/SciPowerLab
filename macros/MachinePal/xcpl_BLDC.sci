// ErturkMe - Copyright 2011 - 2022
// http://erturk.me
// ierturk@ieee.org
// See license.txt

function [x, y, typ] = xcpl_BLDC(job, arg1, arg2)

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
        [ok, Rs, Ls, Lmbd, P, J, Frc, X0, exprs] = getvalue(..
                                                  'Set Brushless DC Machine Parameters',..
                                                  ['Stator Resistance [ohm]';..
                                                  'Stator Inductance [H]';..
                                                  'Permanent Magnet Flux [Wb]';..
                                                  'Number of Pole Pair';..
                                                  'Moment of Inertia [Kgm^2]';..
                                                  'Friction Coefficient [N.m.s]';..
                                                  'X0'],..
                                                  list('vec', 1, 'vec', 1, 'vec', 1, 'vec', 1,..
                                                        'vec', 1, 'vec', 1, 'vec', 5),..
                                                  exprs)

        if ~ok then break, end
          
        model.state = X0;
        model.rpar = [Rs; Ls; Lmbd; P; J; Frc]
        graphics.exprs = exprs
        x.graphics = graphics
        x.model = model
        break
      end

    case 'define' then
      Rs = 4.e-1
      Ls = 2.e-3
      Lmbd = 8.e-3
      P = 2.
      J = 4.e-6
      Frc = 2.e-8
      X0 = [0; 0; 0; 0; 0]
      
      model = scicos_model()
      model.sim = list('xcpl_BLDC', 4)
      model.in = [4]
      model.out = [6]
      model.state = [X0]
      model.dstate = [3 -1 0 1]
      model.rpar = [Rs; Ls; Lmbd; P; J; Frc]
      model.nzcross = 7
      model.nmode = 1
      model.blocktype = 'c'
      model.dep_ut = [%t %t]

      exprs = string(model.rpar); tmp = size(exprs)
      exprs(tmp(1)+1) = strcat(string(X0'), ' ')
      gr_i = ['x=orig(1), y=orig(2), w=sz(1), h=sz(2)';
      'txt=[''Brushless'';''DC Machine'']';
      'xstringb(x + 0.25*w, y + 0.20*h, txt, 0.50*w, 0.60*h, ''fill'')';
      'txt=[''Tload'';'''';''V_abc'']';
      'xstringb(x + 0.02*w, y + 0.08*h, txt, 0.25*w, 0.80*h, ''fill'')';
      'txt=[''theta'';''I_abc'';''wr'']';
      'xstringb(x+0.73*w, y+0.08*h, txt, 0.25*w, 0.80*h, ''fill'')';
      ]
      x = standard_define([4 2], model, exprs, gr_i)

  end

endfunction
