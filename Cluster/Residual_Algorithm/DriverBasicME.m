function DriverBasicME(data,INDMAP,Opt_pars,k,pt)

%% Get nominal parameter values

pars = load_global(data,INDMAP); 

%% Solve model with nominal parameters 
pars(INDMAP)=log(Opt_pars(k,:));
[HR,~,~,Outputs] = model_sol(pars,data);

time = Outputs(:,1);
T_s   = Outputs(:,3);
T_pb = Outputs(:,2);
T_pr  = Outputs(:,4); 

%% Set limits for the axes of each plot 
    Tdata     = data.Tdata;
    SPdata    = data.Pdata;
    Hdata     = data.Hdata;
    Pth       = data.Pthdata;
    Rdata     = data.Rdata;
    Pbar      = data.Pbar;
    Pthbar    = data.Pthbar;
    HminR     = data.HminR;
    HmaxR     = data.HmaxR;
    Hbar      = data.Hbar; 
    Rbar      = data.Rbar; 
    val_start = data.val_start; 
    val_end   = data.val_end; 
    i_ts      = data.i_ts; 
    i_t1      = data.i_t1; 
    i_t2      = data.i_t2; 
    i_te      = data.i_te;
    i_t3      = data.i_t3; 
    i_t4      = data.i_t4;  
    Age       = data.age; 
    dt        = data.dt; 
    val_dat   = data.val_dat;

   
% Determine start and end times of the data set 
t_start = Tdata(1); 
if Tdata(end) > 60 
    t_end = val_end + 30;
else 
    t_end = Tdata(end); 
end 

Tlims   = [t_start, t_end]; 
Plims   = [min(SPdata)-10, max(SPdata)+10];
Pthlims = [-1 41]; 
Hlims   = [min(Hdata)-5,  max(Hdata)+5]; 
efflims = [-.1 .2]; 

%% Save results in a .mat file 
%save nomHR.mat 


%elapsed_time = toc

%% 4 panel figure 

% figure(pt)
% %clf
% set(gcf,'units','normalized','outerposition',[0.2 0.2 .5 .5])
% 
% % BP
% subplot(3,2,1)
% hold on 
% plot(ones(2,1)*val_start,Plims,'k--')
% plot(ones(2,1)*Tdata(i_t1),Plims,'k--')
% plot(ones(2,1)*Tdata(i_t2),Plims,'k:')
% plot(ones(2,1)*val_end,Plims,'k--')
% plot(ones(2,1)*Tdata(i_t3),Plims,'k--')
% plot(ones(2,1)*Tdata(i_t4),Plims,'k--')
% %plot(Tdata,Pdata,'b')
% plot(Tdata,SPdata,'b','linewidth',4)
% 
% set(gca,'FontSize',15)
% xlim(Tlims)
% ylim(Plims)
% yticks(90:30:150)
% ylabel('BP (bpm)')
% 
% % Pth
% subplot(3,2,2)
% hold on 
% 
% plot(ones(2,1)*val_start,Pthlims,'k--')
% plot(ones(2,1)*Tdata(i_t1),Pthlims,'k--')
% plot(ones(2,1)*Tdata(i_t2),Pthlims,'k:')
% plot(ones(2,1)*val_end,Pthlims,'k--')
% plot(ones(2,1)*Tdata(i_t3),Pthlims,'k--')
% <<<<<<< HEAD
% plot(ones(2,1)*Tdata(i_t4),Pthlims,'k--')
% plot(Tdata,Pth,'b','linewidth',3)
% =======
% %plot(ones(2,1)*Tdata(i_t4),Pthlims,'k--')
% plot(Tdata,Pth,'b')
% >>>>>>> 7e9db5e512b725559a6424cdeed931341c162307
% 
% set(gca,'FontSize',15)
% xlim(Tlims)
% ylim(Pthlims)
% yticks(0:15:40)
% ylabel('P_{th} (bpm)')
% 
% % HR 
% subplot(3,2,3)
% hold on 
% plot(ones(2,1)*val_start,Hlims,'k--')
% plot(ones(2,1)*Tdata(i_t1),Hlims,'k--')
% plot(ones(2,1)*Tdata(i_t2),Hlims,'k:')
% plot(ones(2,1)*val_end,Hlims,'k--')
% plot(ones(2,1)*Tdata(i_t3),Hlims,'k--')
% <<<<<<< HEAD
% plot(ones(2,1)*Tdata(i_t4),Hlims,'k--')
% plot(Tdata,Hdata,'r','linewidth',3)
% plot(Tdata,HR,'b','linewidth',3)
% =======
% %plot(ones(2,1)*Tdata(i_t4),Hlims,'k--')
% plot(Tdata,Hdata,'b')
% plot(Tdata,HR,'r')
% >>>>>>> 7e9db5e512b725559a6424cdeed931341c162307
% 
% set(gca,'FontSize',15)
% xlim(Tlims)
% ylim(Hlims)
% yticks(60:30:140)
% xlabel('Time (s)')
% ylabel('HR (bpm)')
% 
% % Neural tones
% subplot(3,2,4)
% hold on 
% plot(ones(2,1)*val_start,efflims,'k--')
% plot(ones(2,1)*Tdata(i_t1),efflims,'k--')
% plot(ones(2,1)*Tdata(i_t2),efflims,'k:')
% plot(ones(2,1)*val_end,efflims,'k--')
% plot(ones(2,1)*Tdata(i_t3),efflims,'k--')
% <<<<<<< HEAD
% plot(ones(2,1)*Tdata(i_t4),efflims,'k--')
% plot(Tdata,T_pr * exp(pars(20)),'color',[.5 0 .5],'linewidth',3) % purple 
% plot(Tdata,T_s * exp(pars(21)),'color',[0 0.75 .75],'linewidth',3)  % slightly darker green than the 'g' command
% =======
% %plot(ones(2,1)*Tdata(i_t4),efflims,'k--')
% plot(Tdata,T_pr,'color',[.5 0 .5]) % purple 
% plot(Tdata,T_s,'color',[0 0.75 .75])  % slightly darker green than the 'g' command
% >>>>>>> 7e9db5e512b725559a6424cdeed931341c162307
% 
% set(gca,'FontSize',15)
% xlim(Tlims)
% ylim(efflims)
% % yticks(0:20:140)
% xlabel('Time (s)')
% ylabel('Outflow')
% 
% 
% subplot(3,2,5)
% hold on 
% plot(ones(2,1)*val_start,[0 0.4],'k--')
% plot(ones(2,1)*Tdata(i_t1),[0 0.4],'k--')
% plot(ones(2,1)*Tdata(i_t2),[0 0.4],'k:')
% plot(ones(2,1)*val_end,[0 0.4],'k--')
% plot(ones(2,1)*Tdata(i_t3),[0 0.4],'k--')
% plot(ones(2,1)*Tdata(i_t4),[0 0.4],'k--')
% plot(Tdata,T_pb * exp(pars(19)),'m','linewidth',3)
% 
% set(gca,'FontSize',15)
% xlim(Tlims)
% ylim([0 0.4])
% xlabel('Time (s)')
% ylabel('Outflow')
% % print('dpng','Plots_HPV3_20151209_Val1_WS.png')

%% This section has the code if you want to do the gray boxes behind each phase 


% %Times for VM phases tsVM = Tnew(t_start); t1 = Tnew(k_SPendI); t2 =
% Tnew(k_SPminII); teVM = Tnew(te); trVM = Tnew(tr); t4VM = Tnew(t4);
% 
% %Identity I = ones(2,1);
% 
% %X values for shaded regions for each VM phase x1   = [tsVM t1 t1 tsVM];
% x2   = [t1 teVM teVM t1]; x3   = [teVM trVM trVM teVM]; x4   = [trVM t4VM
% t4VM trVM];
% 
% % %Y values for shaded regions for each VM phase
% 
% 
% yH   = [Hlims(1) Hlims(1) Hlims(2) Hlims(2)]; 
% yP   = [Plims(1) Plims(1) Plims(2) Plims(2)];
% ySP  = [SPlims(1) SPlims(1) SPlims(2) SPlims(2)]; 
% yPth = [Pthlims(1) Pthlims(1) Pthlims(2) Pthlims(2)]; 
% yeff = [efflims(1) efflims(1) efflims(2) efflims(2)]; 
% yTpr = [Tprlims(1) Tprlims(1) Tprlims(2) Tprlims(2)]; 
% yE   = [Elims(1) Elims(1) Elims(2) Elims(2)]; 
% 
% %Colors 
% gray  = [.875 .875 .875]; 
% lgray = [.95 .95 .95];


% figure(1)
% plot(Tdata,Hdata,'LineWidth',2.5)
% 
% figure(2)
% plot(Tdata,HR,'LineWidth',2.5)
% 
% figure(3)
% plot(val_dat(:,1),val_dat(:,4),'LineWidth',2.5)

figure(4)

subplot(2,2,1)

hold on
   set(gca,'Fontsize',20)
     xline(Tdata(i_t2),'k--')
     rectangle('Position',[val_start -10 Tdata(i_t1)-val_start 200],'FaceColor',[.8 .8 .8])
     rectangle('Position',[Tdata(i_t1) -10 val_end-Tdata(i_t1) 200],'FaceColor',[.9 .9 .9])
     rectangle('Position',[val_end -10 Tdata(i_t3)-val_end 200],'FaceColor',[.8 .8 .8])
     rectangle('Position',[Tdata(i_t3) -10 Tdata(i_t4)-Tdata(i_t3) 200],'FaceColor',[.9 .9 .9])
%      plot(ones(2,1)*val_start,Plims,'k--')
%      plot(ones(2,1)*Tdata(i_t1),Plims,'k--')
%     plot(ones(2,1)*Tdata(i_t2),Plims,'k--')
%      plot(ones(2,1)*val_end,Plims,'k--')
%      plot(ones(2,1)*Tdata(i_t3),Plims,'k--')
%      plot(ones(2,1)*Tdata(i_t4),Plims,'k--')

   hold on
   plot(val_dat(:,1),val_dat(:,4),'Color',[0 .7 1],'LineWidth',1)
   plot(Tdata-Tdata(1),SPdata,'b','LineWidth',3)
%    yticks([])
%    xticks([])
   ylabel('BP (mmHg)')
   xlim([0 60])
   ylim([0 170])
   
   subplot(2,2,2)
   
   set(gca,'Fontsize',20)
     xline(Tdata(i_t2),'k--')
     rectangle('Position',[val_start -10 Tdata(i_t1)-val_start 200],'FaceColor',[.8 .8 .8])
     rectangle('Position',[Tdata(i_t1) -10 val_end-Tdata(i_t1) 200],'FaceColor',[.9 .9 .9])
     rectangle('Position',[val_end -10 Tdata(i_t3)-val_end 200],'FaceColor',[.8 .8 .8])
     rectangle('Position',[Tdata(i_t3) -10 Tdata(i_t4)-Tdata(i_t3) 200],'FaceColor',[.9 .9 .9])
   
   hold on
   plot(Tdata-Tdata(1), Hdata,'b','LineWidth',3)
   plot(Tdata,HR,'Color','r','LineWidth',3)
%    plot(Tdata-Tdata(1), HR_LM,'r','LineWidth',4)
   

   xlabel('Time (s)')
   ylabel('HR (bpm)')
   xlim([0 60])
   ylim([60 130])
   yticks([60 80 100 120])
%    xticks([])
   
   
    subplot(2,2,3)  
    
     hold on
     xline(Tdata(i_t2),'k--')
     rectangle('Position',[val_start -10 Tdata(i_t1)-val_start 200],'FaceColor',[.8 .8 .8])
     rectangle('Position',[Tdata(i_t1) -10 val_end-Tdata(i_t1) 200],'FaceColor',[.9 .9 .9])
     rectangle('Position',[val_end -10 Tdata(i_t3)-val_end 200],'FaceColor',[.8 .8 .8])
     rectangle('Position',[Tdata(i_t3) -10 Tdata(i_t4)-Tdata(i_t3) 200],'FaceColor',[.9 .9 .9])
     plot(Tdata,Pth,'Color','b','LineWidth',3)
     set(gca,'Fontsize',20)
     xlim([0,60])
     ylim([0,50])
     xlabel('Time (s)')
     ylabel('Pth (mmHg)')
     
     return
