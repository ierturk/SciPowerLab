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

// parameters
#define Rs			(GetRparPtrs(blk)[0])
#define Rr			(GetRparPtrs(blk)[1])
#define Ls			(GetRparPtrs(blk)[2])
#define Lr			(GetRparPtrs(blk)[3])
#define Lm			(GetRparPtrs(blk)[4])
#define Pn			(GetRparPtrs(blk)[5])
#define J			(GetRparPtrs(blk)[6])

#define In			(GetRparPtrs(blk)[7])
#define Vn			(GetRparPtrs(blk)[8])
#define fn			(GetRparPtrs(blk)[9])
#define pi			3.14

// parameter in pu
#define Ib			(In*sqrt(2.))
#define Vb			(Vn*sqrt(2.))
#define Wb			(2.*pi*fn)
#define Phib		(Vb/Wb)
#define Zb			(Vb/Ib)
#define Tb			(3./2.*Vb*Ib/Wb)
#define rs			(Rs/Zb)
#define rr			(Rr/Zb)
#define xs			(Wb*Ls/Zb)
#define xr			(Wb*Lr/Zb)
#define xsig		((Ls - Lm*Lm/Lr)*Wb/Zb)
#define xm			(Wb*Lm/Zb)
#define Tr			(xr/rr/Wb)
#define Tm			(J*Wb/Tb/(Pn/2.))
#define Ts2			(1./(rs*Wb/xsig + xm*xm/xsig/xr/Tr))

void xcpl_IMPU(scicos_block *blk, int flag)
{
	int i;

	switch (flag)
	{
		case Initialization:
				GetWorkPtrs(blk) = (double *)MALLOC(sizeof(double)*26);
				
				W[0] = -1./Ts2; W[1] = 0; W[2] = xm/xsig/xr/Tr; W[3] = xm/xsig/xr*Wb;
				W[4] = 0; W[5] = -1./Ts2; W[6] = -xm/xsig/xr*Wb; W[7] = xm/xsig/xr/Tr;
				W[8] = xm/Tr; W[9] = 0; W[10] = -1./Tr; W[11] = -Wb;
				W[12] = 0; W[13] = xm/Tr; W[14] = Wb; W[15] = -1./Tr;
      
				W[16] = Wb/xsig; W[17] = 0;
				W[18] = 0; W[19] = Wb/xsig;
				W[20] = 0; W[21] = 0;
				W[22] = 0; W[23] = 0;
      
				W[24] = xm/Tm/xr*(Pn/2); W[25] = 1./Tm;

				break;

		case Ending:
				FREE(GetWorkPtrs(blk));
				break;

		case DerivativeState:
				dX[0] = W[0]*X[0] + W[2]*X[2] + W[3]*X[3]*X[4] + W[16]*U[0];
				dX[1] = W[5]*X[1] + W[6]*X[2]*X[4] + W[7]*X[3] + W[19]*U[1];
      
				dX[2] = W[8]*X[0] + W[10]*X[2] + W[11]*X[3]*X[4];
				dX[3] = W[13]*X[1] + W[14]*X[2]*X[4] + W[15]*X[3];
      
				dX[4] = W[24]*(X[2]*X[1] - X[3]*X[0]) - W[25]*U[2];
				break;

		case StateUpdate:
				break;

		case OutputUpdate:
				for(i= 0;i < 5; i++) Y[i] = X[i];
				break;
	}
}
