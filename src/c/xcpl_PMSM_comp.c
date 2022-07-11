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
#define Rs			(GetRparPtrs(blk)[0])
#define Lq			(GetRparPtrs(blk)[1])
#define Ld			(GetRparPtrs(blk)[1])
#define Lmbd		(GetRparPtrs(blk)[3])
#define P			(GetRparPtrs(blk)[4])
#define Jn			(GetRparPtrs(blk)[5])
#define Frc			(GetRparPtrs(blk)[6])
#define pi          3.14
#define sqrt3       1.732

void xcpl_PMSM(scicos_block *blk, int flag)
{
	int i;

	switch (flag)
	{
		case Initialization:
			GetWorkPtrs(blk) = (double *)MALLOC(sizeof(double)*4);
			W[0] = 0; W[1] = 0; W[2] = 0; W[3] = 0;
			break;

		case Ending:
			FREE(GetWorkPtrs(blk));
			break;
        
		case DerivativeState:

			W[0] = U[0]*cos(X[3]) + U[1]*sin(X[3]);
			W[1] = -U[0]*sin(X[3]) + U[1]*cos(X[3]);
			W[3] = 3./2.*P/2.*(Lmbd*X[1] + (Ld - Lq)*X[0]*X[1]);

			dX[0] = 1./Ld*(W[0] - Rs*X[0] + Lq*P/2.*X[1]*X[2]);
			dX[1] = 1./Lq*(W[1] - Rs*X[1] - (Ld*X[0] + Lmbd)*P/2.*X[2]);

			dX[2] = 1./Jn*(W[3] - Frc*X[2] - U[2]);

			dX[3] = X[2];
			break;

		case StateUpdate:
			// if (get_phase_simulation() == 1)
			{
				if(J[0] == 1) X[3] -= 2.*pi;
				else if(J[1] == -1) X[3] += 2.*pi;
			}
			break;

        case 9:
			G[0] = X[3] - 2*pi;
			G[1] = X[3];

			break;

		case OutputUpdate:
			Y[0] = X[0]*cos(X[3]) - X[1]*sin(X[3]);
			Y[1] = X[0]*sin(X[3]) + X[1]*cos(X[3]);
            Y[2] = X[2];
            Y[3] = X[3];
            break;

		default:
				break;
	}
}
