%DriverBasic_LM
function [HR_LM] = Func_DriverBasic_LM(pt_file_name,INDMAP,k)
%     clear all
    %close all
    tic

    %% Inputs

%     load ../ForwardEvaluation/nomHR.mat
    load(strcat(pt_file_name));

    echoon = 0; 
    senson = 0; 

    %% Get nominal parameter values

    [pars,low,hi] = load_global(data, INDMAP); 

    %Global parameters
    
    ALLPARS  = pars;
    ODE_TOL  = 1e-8; 
    DIFF_INC = sqrt(ODE_TOL);

    gpars.INDMAP   = INDMAP;
    gpars.ALLPARS  = ALLPARS;
    gpars.ODE_TOL  = ODE_TOL;
    gpars.DIFF_INC = DIFF_INC;
    gpars.echoon   = echoon;
    gpars.senson   = senson; 

    data.gpars = gpars;

    %% Optimization - lsqnonlin

    optx   = pars(INDMAP); 
    opthi  = hi(INDMAP);
    optlow = low(INDMAP);

    maxiter = 30; 
    mode    = 2; 
    nu0     = 2.d-1; 

    [xopt, histout, costdata, jachist, xhist, rout, sc] = ...
         newlsq_v2(optx,'opt_wrap',1.d-3,maxiter,...
         mode,nu0,opthi,optlow,data); 

    pars_LM = pars;
    pars_LM(INDMAP) = xopt; 

    [HR_LM,rout,J,Outputs] = model_sol(pars_LM,data);

    optpars = exp(pars_LM);
    disp('optimized parameters')
    disp([INDMAP' optpars(INDMAP) exp(hi(INDMAP)) exp(low(INDMAP))])

    time = Outputs(:,1); 
    Tpb_LM  = Outputs(:,2);
    Ts_LM   = Outputs(:,3);
    Tpr_LM  = Outputs(:,4); 

%     save optHR.mat 
    save(strcat('Valsalva/optHR_residuals/',pt_file_name(25:end-10),'_',num2str(k),'_optHR.mat'))

    elapsed_time = toc;
    elapsed_time = elapsed_time/60;
end