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
#define W			((SCSREAL_COP *)GetWorkPtrs(blk))


void xcpl_PSDINV(scicos_block *blk, int flag)
{
	int i;

	switch (flag)
	{
		case Initialization:
				GetWorkPtrs(blk) = (double *)MALLOC(sizeof(double)*2);
                W[0] = 0; W[1] = 0;
				break;

		case Ending:
				FREE(GetWorkPtrs(blk));
				break;

		case DerivativeState:
				break;

		case StateUpdate:
              
                Xk[0] = U[3]/3.*(2.*U[0] - U[1] - U[2]);
                Xk[1] = U[3]/sqrt(3.)*(U[1] - U[2]);

				break;

		case OutputUpdate:
				for(i= 0;i < 2; i++) Y[i] = Xk[i];
				break;
	}
}
