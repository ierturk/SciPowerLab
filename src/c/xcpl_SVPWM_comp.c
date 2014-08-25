// StarGate-TR - Copyright 2011
// http://www.stargate-tr.com
// ierturk@stargate-tr.com

#include "scicos_block4.h"

#define U			((SCSREAL_COP *)GetRealInPortPtrs(blk, 1))
#define Y			((SCSREAL_COP *)GetRealOutPortPtrs(blk, 1))
#define X			((SCSREAL_COP *)GetState(blk))
#define dX			((SCSREAL_COP *)GetDerState(blk))
#define Xk			((SCSREAL_COP *)GetDstate(blk))
#define W			((SCSREAL_COP *)GetWorkPtrs(blk))


void xcpl_SVPWM(scicos_block *blk, int flag)
{
	int i;

    SCSREAL_COP r1, r2, r3;
    SCSREAL_COP sect;
    SCSREAL_COP tx, ty, tz;
    SCSREAL_COP t11, t22;
    SCSREAL_COP t0, t1, t2, t_tot;


	switch (flag)
	{
		case Initialization:
				GetWorkPtrs(blk) = (double *)scicos_malloc(sizeof(double)*2);
                W[0] = 0; W[1] = 0;
				break;

		case Ending:
				scicos_free(GetWorkPtrs(blk));
				break;

		case DerivativeState:
				break;

		case StateUpdate:
            
                r1 = 0.5*(U[0]*sqrt(3) + U[1]);
                r2 = 0.5*(-U[0]*sqrt(3) + U[1]);
                r3 = -U[1];

                sect = 0;
                if (r1 > 0) sect = sect + 1;
                if (r2 > 0) sect = sect + 2;
                if (r3 > 0) sect = sect + 4;
    
                tx = U[1]/(U[2]/sqrt(3));
                ty = 0.5*(U[1] + U[0]*sqrt(3))/(U[2]/sqrt(3));
                tz = 0.5*(U[1] - U[0]*sqrt(3))/(U[2]/sqrt(3));
  
                if(sect == 1) {t11 = -tz; t22 = tx;}
                else if(sect == 2) {t11 = tx; t22 = -ty;}
                else if(sect == 3) {t11 = ty; t22 = tz;}
                else if(sect == 4) {t11 = -ty; t22 = -tz;}
                else if(sect == 5) {t11 = -tx; t22 = ty;}
                else if(sect == 6) {t11 = tz; t22 = -tx;}
  
                t_tot = t11 + t22;
                if (t_tot > 1)
                {t1 = t11/t_tot; t2 = t22/t_tot; t0 = 0;}
                else
                {t0 = 1. - t_tot; t1 = t11; t2 = t22;}
  
                if(sect == 1) {Xk[0] = .5*t0; Xk[1] = Xk[0] + t1; Xk[2] = Xk[1] + t2;}
                else if(sect == 2) {Xk[1] = .5*t0; Xk[2] = Xk[1] + t1; Xk[0] = Xk[2] + t2;}
                else if(sect == 3) {Xk[1] = .5*t0; Xk[0] = Xk[1] + t2; Xk[2] = Xk[0] + t1;}
                else if(sect == 4) {Xk[2] = .5*t0; Xk[0] = Xk[2] + t1; Xk[1] = Xk[0] + t2;}
                else if(sect == 5) {Xk[0] = .5*t0; Xk[2] = Xk[0] + t2; Xk[1] = Xk[2] + t1;}
                else if(sect == 6) {Xk[2] = .5*t0; Xk[1] = Xk[2] + t2; Xk[0] = Xk[1] + t1;}

				break;

		case OutputUpdate:
				for(i= 0;i < 3; i++) Y[i] = Xk[i];
				break;
	}
}
