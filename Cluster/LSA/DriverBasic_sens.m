
%DriverBasic_sens

clear all
close all

tic 

T = readtable('../PatientInfo_063021.csv','Headerlines',2);

for pt=[36:117]
    pt
    pt_id = T{pt,1}{1}  

    loadString = strcat('../Valsalva/nomHR_residuals/',pt_id,'_val1_nomHR.mat'); 
    
    
    %DriverBasic

    %% Load data and preprocess data 
     if isfile(strcat('../MatFiles/',pt_id,'_val1_WS.mat'))
        load(loadString)

    %  load ../HPV6_20131029_Val1_WS.mat
    echoon  = 1; 
    printon = 0; 
    %% Get nominal parameter values

    %Global parameters

    ODE_TOL  = 1e-8;
    DIFF_INC = sqrt(ODE_TOL);

    gpars.ODE_TOL  = ODE_TOL;
    gpars.DIFF_INC = DIFF_INC; 
    gpars.echoon = echoon;

    data.gpars = gpars; 

    %% Sensitivity Analysis

    %senseq finds the non-weighted sensitivities
    sens = senseq(pars,data);

    sens = abs(sens); 

    % ranked classical sensitivities
    [M,N] = size(sens);
    for i = 1:N 
        sens_norm(i)=norm(sens(:,i),2);
    end

    %sens_norm = sens_norm(1:end-2); 
    [Rsens,Isens] = sort(sens_norm,'descend');
    display([Isens]); 

    params = {'$A$', '$B$', ...
        '$K_{pb}$','$K_{pr}$','$K_s$', ...
        '$\tau_{pb}$','$\tau_{pr}$','$\tau_s$','$\tau_H$',...
        '$q_w$','$q_{pb}$','$q_{pr}$','$q_{s}$', ...
        '$s_w$','$s_{pb}$','$s_{pr}$','$s_{s}$', ...
        '$H_I$','$H_{pb}$','$H_{pr}$','$H_{s}$', ...
        '$D_s$'}; 

    save(strcat('Sens/sens',pt_id,'_val1.mat')); 
    
     end

    elapsed_time = toc

%     %clear all
%     loadString = strcat('nomHR_HPV',num2str(v(jk)),'val2.mat'); 
%    
%     
%     %DriverBasic
% 
%     %% Load data and preprocess data 
%     load(loadString)
% 
% 
%     %  load ../HPV6_20131029_Val1_WS.mat
%     echoon  = 0; 
%     printon = 0; 
%     %% Get nominal parameter values
% 
%     %Global parameters
%     
%     ODE_TOL  = 1e-8;
%     DIFF_INC = sqrt(ODE_TOL);
% 
%     gpars.ODE_TOL  = ODE_TOL;
%     gpars.DIFF_INC = DIFF_INC; 
%     gpars.echoon = echoon;
% 
%     data.gpars = gpars; 
% 
%     %% Sensitivity Analysis
% 
%     %senseq finds the non-weighted sensitivities
%     sens = senseq(pars,data);
% 
%     sens = abs(sens); 
% 
%     % ranked classical sensitivities
%     [M,N] = size(sens);
%     for i = 1:N 
%         sens_norm(i)=norm(sens(:,i),2);
%     end
% 
%     
%     %sens_norm = sens_norm(1:end-2); 
%     [Rsens,Isens] = sort(sens_norm,'descend');
%     display([Isens]); 
% 
%     params = {'$A$', '$B$', ...
%         '$K_{pb}$','$K_{pr}$','$K_s$', ...
%         '$\tau_{pb}$','$\tau_{pr}$','$\tau_s$','$\tau_H$',...
%         '$q_w$','$q_{pb}$','$q_{pr}$','$q_{s}$', ...
%         '$s_w$','$s_{pb}$','$s_{pr}$','$s_{s}$', ...
%         '$H_I$','$H_{pb}$','$H_{pr}$','$H_{s}$', ...
%         '$D_s$'}; 
% 
%     save(strcat('sens',num2str(v(jk)),'_2.mat'));
% 
%     
% 
%     elapsed_time = toc
end

