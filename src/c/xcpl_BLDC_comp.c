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
#define Ls			(GetRparPtrs(blk)[1])
#define Lmbd		(GetRparPtrs(blk)[2])
#define P			(GetRparPtrs(blk)[3])
#define Jn			(GetRparPtrs(blk)[4])
#define Frc			(GetRparPtrs(blk)[5])
#define pi          3.14

// terminal voltages
#define Vab			(U[0] - U[1])
#define Vbc			(U[1] - U[2])

void xcpl_BLDC(scicos_block *blk, int flag)
{
	int i;

	switch (flag)
	{
		case Initialization:
			GetWorkPtrs(blk) = (double *)MALLOC(sizeof(double)*10);
			W[0] = 0; W[1] = 0; W[2] = 0; W[3] = 0; W[4] = 0;
			W[5] = 0; W[6] = 0; W[7] = 0; W[8] = 0; W[9] = 0;
			break;

		case Ending:
			FREE(GetWorkPtrs(blk));
			break;
        
		case DerivativeState:
			switch(M[0])
			{
				case 0:
					W[0] = 1; W[1] = 6/pi*X[4] + 5; W[2] = -1; break;
				case 1:
					W[0] = -6/pi*X[4] - 3; W[1] = 1; W[2] = -1; break;
				case 2:
					W[0] = -1; W[1] = 1; W[2] = 6/pi*X[4] + 1; break;
				case 3:
					W[0] = -1; W[1] = -6/pi*X[4] + 1; W[2] = 1; break;
				case 4:
					W[0] = 6/pi*X[4] - 3; W[1] = -1; W[2] = 1; break;
				case 5:
					W[0] = 1; W[1] = -1; W[2] = -6/pi*X[4] + 5; break;
			}

			W[3] = P/2.*Lmbd*(W[0]*X[0] + W[1]*X[1] + W[2]*X[2]);

			dX[0] = 1./3./Ls*(2.*Vab + Vbc - 3.*Rs*X[0]
								+ Lmbd*P/2.*X[3]*(-2.*W[0] + W[1] + W[2]));

			dX[1] = 1./3./Ls*(-Vab + Vbc - 3.*Rs*X[1]
								+ Lmbd*P/2.*X[3]*(W[0] -2.*W[1] + W[2]));
								
			dX[2] = -(dX[0] + dX[1]);

			dX[3] = 1./Jn*(W[3] - Frc*X[3] - U[3]);

			dX[4] = X[3];
			break;

		case StateUpdate:

			break;

        case 9:


			// if (get_phase_simulation() == 1)
			{
				G[0] = X[4] + pi;
				G[1] = X[4] + 2.*pi/3.;
				G[2] = X[4] + pi/3.;
				G[3] = X[4];
				G[4] = X[4] - pi/3.;
				G[5] = X[4] - 2.*pi/3.;
				G[6] = X[4] - pi;

				if		(X[4] < -pi) {X[4] += 2.*pi;	M[0] = 5;}
				else if ((X[4] >= -pi) && (X[4] < -2.*pi/3.))		M[0] = 0;
				else if ((X[4] >= -2.*pi/3.) && (X[4] < -pi/3.))	M[0] = 1;
				else if ((X[4] >= -pi/3.) && (X[4] < 0.))			M[0] = 2;
				else if ((X[4] >= 0.) && (X[4] < pi/3.))			M[0] = 3;
				else if ((X[4] >= pi/3.) && (X[4] < 2.*pi/3.))		M[0] = 4;
				else if ((X[4] >= 2.*pi/3.) && (X[4] < pi))			M[0] = 5;
				else if (X[4] > pi) {X[4] -= 2.*pi; M[0] = 0;}
			}

			break;

		case OutputUpdate:
			Y[0] = X[0];
			Y[1] = X[1];
            Y[2] = X[2];
            Y[3] = X[3];
			Y[4] = X[4];
			Y[5] = (M[0] + 0) % 6;
            break;

		default:
				break;
	}
}
