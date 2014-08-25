// StarGate-TR - Copyright 2011
// http://www.stargate-tr.com
// ierturk@stargate-tr.com

function [x, y, typ] = xcpl_PMSM(job, arg1, arg2)

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
        [ok, Rs, Lq, Ld, Lmbd, P, J, Frc, X0, exprs] = getvalue(..
                                                  'Set Permanent Magnet Syncronous Machine Parameters',..
                                                  ['Stator Resistance [ohm]';..
                                                  'Stator Inductance q-axis [H]';..
                                                  'Stator Inductance d-axis [H]';..
                                                  'Permanent Magnet Flux [Wb]';..
                                                  'Number of Pole Pair';..
                                                  'Moment of Inertia [Kgm^2]';..
                                                  'Friction Coefficient [N.m.s]';..
                                                  'X0'],..
                                                  list('vec', 1, 'vec', 1, 'vec', 1, 'vec', 1,..
                                                        'vec', 1, 'vec', 1, 'vec', 1, 'vec', 4),..
                                                  exprs)

        if ~ok then break, end
          
        model.state = [X0]
        model.rpar = [Rs; Lq; Ld; Lmbd; P; J; Frc]
        graphics.exprs = exprs
        x.graphics = graphics
        x.model = model
        break
      end

    case 'define' then
      Rs = 0.01
      Lq = 0.001
      Ld = 0.001
      Lmbd = 0.02
      P = 2.
      J = 0.008
      Frc = 0
      X0 = [0; 0; 0; 0]
      
      model = scicos_model()
      model.sim = list('xcpl_PMSM', 4)
      model.in = [3]
      model.out = [4]
      model.state = [X0]
      model.dstate = []
      model.rpar = [Rs; Lq; Ld; Lmbd; P; J; Frc]
      model.nzcross = 2
      model.blocktype = 'c'
      model.dep_ut = [%t %t]

      exprs = string(model.rpar); tmp = size(exprs)
      exprs(tmp(1)+1) = strcat(string(X0'), ' ')
      gr_i = ['x=orig(1), y=orig(2), w=sz(1), h=sz(2)';
      'txt=[''PMSM'';''Machine'']';
      'xstringb(x + 0.25*w, y + 0.20*h, txt, 0.50*w, 0.60*h, ''fill'')';
      'txt=[''v_dq'';'''';''Tload'']';
      'xstringb(x + 0.02*w, y + 0.08*h, txt, 0.25*w, 0.80*h, ''fill'')';
      'txt=[''i_dq'';''wr'';''theta'']';
      'xstringb(x+0.73*w, y+0.08*h, txt, 0.25*w, 0.80*h, ''fill'')';
      ]
      x = standard_define([4 2], model, exprs, gr_i)

  end

endfunction
