// ErturkMe - Copyright 2011 - 2022
// http://erturk.me
// ierturk@ieee.org
// See license.txt

function [x, y, typ] = xcpl_IMPU(job, arg1, arg2)

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
        [ok, Rs, Rr, Ls, Lr, Lm, Pn, Jn, In, Vn, fn, X0, exprs] = getvalue(..
                                                  'Set Induction Machine Parameters',..
                                                  ['Stator Resistance [ohm]';..
                                                  'Rotor Resistance [ohm]';..
                                                  'Stator Inductance [H]';..
                                                  'Rotor Inductance [H]';..
                                                  'Mutual Inductance [H]';..
                                                  'Number of Pole';..
                                                  'Moment of Inertia [Kgm2]';..
                                                  'Nominal Current [A]';..
                                                  'Nominal Voltage [V]';..
                                                  'Nominal Frequency [Hz]';..
                                                  'X0'],..
                                                  list('vec', 1, 'vec', 1, 'vec', 1, 'vec', 1,..
                                                        'vec', 1, 'vec', 1, 'vec', 1, 'vec', 1,..
                                                         'vec', 1, 'vec', 1, 'vec', 5),..
                                                  exprs)

        if ~ok then break, end
          
        model.state = [X0]
        model.rpar = [Rs; Rr; Ls; Lr; Lm; Pn; Jn; In; Vn; fn]
        graphics.exprs = exprs
        x.graphics = graphics
        x.model = model
        break
      end

    case 'define' then
      Rs = 9.9
      Rr = 12.345
      Ls = 0.661
      Lr = 0.661
      Lm = 0.590
      Pn = 4.
      Jn = 0.008
      In = 1.9
      Vn = 127.
      fn = 28.8636
      X0 = [0; 0; 0; 0; 0]
      
      model = scicos_model()
      model.sim = list('xcpl_IMPU', 4)
      model.in = [3]
      model.out = [5]
      model.state = [X0]
      model.dstate = [5]
      model.rpar = [Rs; Rr; Ls; Lr; Lm; Pn; Jn; In; Vn; fn]
      model.blocktype = 'c'
      model.dep_ut = [%t %t]

      exprs = string(model.rpar); tmp = size(exprs)
      exprs(tmp(1)+1) = strcat(string(X0'), ' ')
      gr_i = ['x=orig(1), y=orig(2), w=sz(1), h=sz(2)';
      'txt=[''Induction'';''Machine'']';
      'xstringb(x + 0.25*w, y + 0.20*h, txt, 0.50*w, 0.60*h, ''fill'')';
      'txt=[''V_dq'';'''';''Tload'']';
      'xstringb(x + 0.02*w, y + 0.08*h, txt, 0.25*w, 0.80*h, ''fill'')';
      'txt=[''I_dq'';''Phi_dq'';''w'']';
      'xstringb(x+0.73*w, y+0.08*h, txt, 0.25*w, 0.80*h, ''fill'')';
      ]
      x = standard_define([4 2], model, exprs, gr_i)

  end

endfunction
