// ErturkMe - Copyright 2011 - 2022
// http://erturk.me
// ierturk@ieee.org
// See license.txt

#include "api_scilab.h"
#include "scicos_block4.h"

#define U			((SCSREAL_COP *)GetRealInPortPtrs(blk, 1))
#define Y			((SCSREAL_COP *)GetRealOutPortPtrs(blk, 1))
#define X			((SCSREAL_COP *)GetState(blk))
#define dX			((SCSREAL_COP *)GetDerState(blk))
#define Xk			((SCSREAL_COP *)GetDstate(blk))
#define W           ((SCSREAL_COP *)GetWorkPtrs(blk))
#define G           (GetGPtrs(blk))
#define J           (GetJrootPtrs(blk))
#define M           (GetModePtrs(blk))

// parameters
#define Vdc			(GetRparPtrs(blk)[0])
#define Kp			(GetRparPtrs(blk)[1])
#define Ki			(GetRparPtrs(blk)[2])
#define pi			3.14 

void xcpl_PMSC(scicos_block *blk, int flag)
{
	int i;

	switch (flag)
	{
		case Initialization:
			GetWorkPtrs(blk) = (double *)MALLOC(sizeof(double)*2);
			W[0] = W[1] = 0;
			break;

		case Ending:
			FREE(GetWorkPtrs(blk));
			break;
        
		case DerivativeState:
			W[0] = U[4] - U[2];
			dX[0] = W[0];
			break;

		case StateUpdate:
						
			if		(X[0] > Vdc) X[0] = Vdc;
			else if	(X[0] < 0.) X[0] = 0.1*Vdc;

			W[1] = X[0] + Kp*W[0];
			if		(W[1] > Vdc) W[1] = Vdc;
			else if	(W[1] < 0.1) W[1] = 0.1*Vdc;
			
			break;

        case 9:        
			break;

		case OutputUpdate:
			Y[0] = -W[1]*sin(U[3]);
            Y[1] = W[1]*cos(U[3]);
            break;

		default:
				break;
	}
}
