// StarGate-TR - Copyright 2011
// http://www.stargate-tr.com
// ierturk@stargate-tr.com

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

void xcpl_BLSC(scicos_block *blk, int flag)
{
	int i;

	switch (flag)
	{
		case Initialization:
			GetWorkPtrs(blk) = (double *)scicos_malloc(sizeof(double)*5);
			W[0] = W[1] = W[2] = W[3] = W[4] = 0;
			break;

		case Ending:
			scicos_free(GetWorkPtrs(blk));
			break;
        
		case DerivativeState:
			W[0] = U[6] - U[3];
			dX[0] = W[0];
			break;

		case StateUpdate:
						
			if		(X[0] > Vdc) X[0] = Vdc;
			else if	(X[0] < 0.) X[0] = 0.1*Vdc;

			W[1] = X[0] + Kp*W[0];
			if		(W[1] > Vdc) W[1] = Vdc;
			else if	(W[1] < 0.1) W[1] = 0.1*Vdc;
			
			switch((int)U[5])
			{
				case 0:
					W[2] = 1; W[3] = 0; W[4] = -1; break;
				case 1:
					W[2] = 0; W[3] = 1; W[4] = -1; break;
				case 2:
					W[2] = -1; W[3] = 1; W[4] = 0; break;
				case 3:
					W[2] = -1; W[3] = 0; W[4] = 1; break;
				case 4:
					W[2] = 0; W[3] = -1; W[4] = 1; break;
				case 5:
					W[2] = 1; W[3] = -1; W[4] = 0; break;
			}

			break;

        case 9:        
			break;

		case OutputUpdate:
			Y[0] = W[1]*W[2];
            Y[1] = W[1]*W[3];
            Y[2] = W[1]*W[4];
            break;

		default:
				break;
	}
}
