%DriverBasic 

clear all
%close all

tic 

%% Inputs

echoon  = 1; 
printon = 0; 

%% Load data and preprocess data 
% load ../HPV3_20151209_Val1_WS.mat
%  load ../HPV6_20131029_Val1_WS.mat 
gpath = '/Volumes/GoogleDrive/.shortcut-targets-by-id/1Vnypyb_cIdCMJ49vzcg8V7cWblpVCeYZ/HPV_Data/Prepped_workspaces/Valsalva/';
HPV_file = 'HPV4_20131025';
load(strcat(gpath,HPV_file,'_Val1_WS.mat'))
load(strcat('../Optimized/',HPV_file,'_optimized.mat'))
dt = mean(diff(Tdata)); 

% Rescale times to start at 0
val_start = val_start - Tdata(1); 
val_end   = val_end - Tdata(1); 
Tdata     = Tdata - Tdata(1); 

% Determine start and end times of the data set 
t_start = Tdata(1); 
if Tdata(end) > 60 
    t_end = val_end + 30;
else 
    t_end = Tdata(end); 
end 
    
% Find the indices of the time data points that are closest to the VM start
% and end times 
[~,i_ts] = min(abs(Tdata - val_start)); 
[~,i_te] = min(abs(Tdata - val_end)); 

%% Find steady-state baseline values up to VM start

HminR = min(Hdata(1:i_ts - 1)); 
HmaxR = max(Hdata(1:i_ts - 1)); 
Hbar = trapz(Hdata(1:i_ts - 1))/(i_ts - 1); 
Rbar = trapz(Rdata(1:i_ts - 1))/(i_ts - 1); 
Pbar = trapz(SPdata(1:i_ts - 1))/(i_ts - 1); 

%% Find time for end of phase I 
% Select the point at which the SBP recuperates to baseline within 10 s of
% the end of the breath hold 
[~,i_t1] = min(abs(SPdata(i_ts:i_ts+round(5/dt)) - Pbar)); 
i_t1 = i_ts + i_t1; 

%% Find time for middle of phase II 
% Select the point that which the SBP reaches a minimum during phase II 
[~,i_t2] = min(SPdata(i_t1:i_te-round(1/dt))); % subtract 1 second to avoid drop off from breath hold
i_t2 = i_t2 + i_t1; 

%% Find time for end of phase III 
% Select the point at which the SBP recuperates to baseline within 5 s of
% the end of the breath hold 
[~,i_t3] = min(abs(SPdata(i_te:i_te+round(5/dt)) - Pbar)); 
i_t3 = i_te + i_t3; 

%% Find time for end of phase IV 
% Select the point at which the SBP returns to baseline after the overshoot
ind = find(SPdata(i_t3:end) <= Pbar, 1, 'first'); 
if isempty(ind) == 1
    i_t4 = length(SPdata); 
else 
    i_t4 = i_t3 + ind; 
end 

%Check in case t4 = tr
if i_t4 == i_t3 
    ind2 = find(SPdata(tr+round(5/dt):end) >= Pbar,1,'last');
    t4 = tr + round(5/dt) + ind2 - 1; 
end  

%% Make thoracic pressure signal 

Rdata = Rdata*1000; 
Rnew = -Rdata; 

a = findpeaks(Rnew(1:i_ts-1)); 
b = findpeaks(-Rnew(1:i_ts-1)); 
b = -b; 
R_exh = mean(a); 
R_inh = mean(b);
R_amp = R_exh - R_inh; 

Amp_norm = 6 - 3.5; 
Amp      = Amp_norm/R_amp; 
RR       = Amp*Rnew; 

a      = findpeaks(-RR(1:i_ts-1));
R_exh  = -mean(a); 
m      = 3.5 - R_exh;
P_resp = RR+m ; 

%Thoracic pressure 
Pth = zeros(size(Tdata)); 
for i = 1:length(Tdata)
    t = Tdata(i); 
        if (t > val_start) && (t < val_end)
            p = 40*(1 - exp(-2*(t - val_start)));
        else 
            p = P_resp(i); 
        end 
     Pth(i) = p; 
end 
      
% Smooth out Pth 
Pth = movmean(Pth,10);

% Find average baseline Pth 
Pthbar = trapz(Pth(1:i_ts-1))/(i_ts-1); 

%% Create data structure 

data.Tdata     = Tdata;
data.Pdata     = SPdata; 
data.Hdata     = Hdata;
data.Pthdata   = Pth;
data.Rdata     = Rdata; 
data.Pbar      = Pbar;
data.Pthbar    = Pthbar;
data.HminR     = HminR;
data.HmaxR     = HmaxR;
data.Hbar      = Hbar; 
data.Rbar      = Rbar; 
data.val_start = val_start; 
data.val_end   = val_end; 
data.i_ts      = i_ts; 
data.i_t1      = i_t1; 
data.i_t2      = i_t2; 
data.i_te      = i_te;
data.i_t3      = i_t3; 
data.i_t4      = i_t4;  
data.age       = Age; 
data.dt        = dt; 

%Global parameters substructure
gpars.echoon = echoon; 

data.gpars   = gpars; 

%% Get nominal parameter values

pars = saveDat.pars;%load_global(data); 

%% Solve model with nominal parameters 

[HR,~,~,Outputs] = model_sol(pars,data);

time = Outputs(:,1);
T_s   = Outputs(:,3);
T_pr  = Outputs(:,4); 

%% Set limits for the axes of each plot 

Tlims   = [t_start, t_end]; 
Plims   = [min(Pdata)-10, max(Pdata)+10];
Pthlims = [-1 41]; 
Hlims   = [min(Hdata)-5,  max(Hdata)+5]; 
efflims = [-.1 1.25]; 

%% Save results in a .mat file 
save nomHR.mat 

elapsed_time = toc

%% 4 panel figure 

figure(100)
clf
set(gcf,'units','normalized','outerposition',[0.2 0.2 .5 .5])

% BP
subplot(2,2,1)
hold on 
plot(ones(2,1)*val_start,Plims,'k--')
plot(ones(2,1)*Tdata(i_t1),Plims,'k--')
plot(ones(2,1)*Tdata(i_t2),Plims,'k:')
plot(ones(2,1)*val_end,Plims,'k--')
plot(ones(2,1)*Tdata(i_t3),Plims,'k--')
plot(ones(2,1)*Tdata(i_t4),Plims,'k--')
plot(Tdata,Pdata,'b')
plot(Tdata,SPdata,'b','linewidth',2)

set(gca,'FontSize',15)
xlim(Tlims)
ylim(Plims)
ylabel('BP (bpm)')

% Pth
subplot(2,2,2)
hold on 

plot(ones(2,1)*val_start,Pthlims,'k--')
plot(ones(2,1)*Tdata(i_t1),Pthlims,'k--')
plot(ones(2,1)*Tdata(i_t2),Pthlims,'k:')
plot(ones(2,1)*val_end,Pthlims,'k--')
plot(ones(2,1)*Tdata(i_t3),Pthlims,'k--')
plot(ones(2,1)*Tdata(i_t4),Pthlims,'k--')
plot(Tdata,Pth,'b')

set(gca,'FontSize',15)
xlim(Tlims)
ylim(Pthlims)
ylabel('P_{th} (bpm)')

% HR 
subplot(2,2,3)
hold on 
plot(ones(2,1)*val_start,Hlims,'k--')
plot(ones(2,1)*Tdata(i_t1),Hlims,'k--')
plot(ones(2,1)*Tdata(i_t2),Hlims,'k:')
plot(ones(2,1)*val_end,Hlims,'k--')
plot(ones(2,1)*Tdata(i_t3),Hlims,'k--')
plot(ones(2,1)*Tdata(i_t4),Hlims,'k--')
plot(Tdata,Hdata,'b')
plot(Tdata,HR,'r')

set(gca,'FontSize',15)
xlim(Tlims)
ylim(Hlims)
xlabel('Time (s)')
ylabel('HR (bpm)')

% Neural tones
subplot(2,2,4)
hold on 
plot(ones(2,1)*val_start,efflims,'k--')
plot(ones(2,1)*Tdata(i_t1),efflims,'k--')
plot(ones(2,1)*Tdata(i_t2),efflims,'k:')
plot(ones(2,1)*val_end,efflims,'k--')
plot(ones(2,1)*Tdata(i_t3),efflims,'k--')
plot(ones(2,1)*Tdata(i_t4),efflims,'k--')
plot(Tdata,T_pr,'color',[.5 0 .5]) % purple 
plot(Tdata,T_s,'color',[0 0.75 .75])  % slightly darker green than the 'g' command

set(gca,'FontSize',15)
xlim(Tlims)
ylim(efflims)
xlabel('Time (s)')
ylabel('Outflow')
% print('dpng','Plots_HPV3_20151209_Val1_WS.png')


return 

%% This section has the code if you want to do the gray boxes behind each phase 

% {
% Times for VM phases
tsVM = Tnew(t_start);
t1 = Tnew(k_SPendI);
t2 = Tnew(k_SPminII);
teVM = Tnew(te); 
trVM = Tnew(tr); 
t4VM = Tnew(t4); 

% Identity
I = ones(2,1); 

% X values for shaded regions for each VM phase
x1   = [tsVM t1 t1 tsVM];
x2   = [t1 teVM teVM t1]; 
x3   = [teVM trVM trVM teVM];
x4   = [trVM t4VM t4VM trVM]; 

% Y values for shaded regions for each VM phase
yH   = [Hlims(1) Hlims(1) Hlims(2) Hlims(2)]; 
yP   = [Plims(1) Plims(1) Plims(2) Plims(2)];
ySP  = [SPlims(1) SPlims(1) SPlims(2) SPlims(2)]; 
yPth = [Pthlims(1) Pthlims(1) Pthlims(2) Pthlims(2)]; 
yeff = [efflims(1) efflims(1) efflims(2) efflims(2)]; 
yTpr = [Tprlims(1) Tprlims(1) Tprlims(2) Tprlims(2)]; 
yE   = [Elims(1) Elims(1) Elims(2) Elims(2)]; 

% Colors 
gray  = [.875 .875 .875]; 
lgray = [.95 .95 .95];
% }
