
%DriverBasic_sens

clear all
close all

tic 

load Valsalva/File_name_cell_06072021_short.mat   

for kk=20:35
    u{kk-19} = strcat(cell_of_file_names{kk,1}(1:end-9))
end

for jkl = 1:length(u)
    %clear all
    u{jkl}
    loadString = strcat('nomHR_',u{jkl},'_val1.mat'); 
    
    
    %DriverBasic

    %% Load data and preprocess data 
    load(loadString)

    %  load ../HPV6_20131029_Val1_WS.mat
    echoon  = 0; 
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

    save(strcat('sens',u{jkl},'_val1.mat')); 

    elapsed_time = toc

    
    %{ 
    %clear all
    loadString = strcat('nomHR_HPV',num2str(v(jk)),'val2.mat'); 
   
    
    %DriverBasic

    %% Load data and preprocess data 
    load(loadString)


    %  load ../HPV6_20131029_Val1_WS.mat
    echoon  = 0; 
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

    save(strcat('sens',num2str(v(jk)),'_2.mat'));

    

   elapsed_time = toc
end
%}
