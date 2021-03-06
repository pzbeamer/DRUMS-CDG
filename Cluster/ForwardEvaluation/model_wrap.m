%--------------------------------------------------------------------------
%Used to fix some parameters and let the others vary (INDMAP) before
%solving ODE
%--------------------------------------------------------------------------

function [J,HR,rout] = model_wrap(pars,data)

ALLPARS = data.gpars.ALLPARS;
INDMAP  = data.gpars.INDMAP;

tpars = ALLPARS;
tpars(INDMAP') = pars;


[HR,rout,J] = model_sol(tpars,data);
%[HR,rout,J,Outputs]
