load File_name_cell_06072021_short.mat   
% q = [1 3 5 6 8 9 10 14 17 24 29 30];
q = [30];

for i=1:length(q)
    u{i} = strcat(cell_of_file_names{q(i),1}(1:end-9))
end


for j = 1:length(u)
    load(strcat('Valsalva/nomHR_residuals/',u{j},'_Val1_30_nomHR.mat'))
    load(strcat('Valsalva/optHR_residuals/',u{j},'_Val1_30_optHR6.mat'))
    
    h = figure;
    set(gcf,'units','normalized','outerposition',[0.2 0.2 .5 .5])
    % BP
    subplot(3,2,1)
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
    subplot(3,2,2)
    hold on 

    plot(ones(2,1)*val_start,Pthlims,'k--')
    plot(ones(2,1)*Tdata(i_t1),Pthlims,'k--')
    plot(ones(2,1)*Tdata(i_t2),Pthlims,'k:')
    plot(ones(2,1)*val_end,Pthlims,'k--')
    plot(ones(2,1)*Tdata(i_t3),Pthlims,'k--')
    plot(ones(2,1)*Tdata(i_t4),Pthlims,'k--')
    plot(Tdata,Pth,'b','linewidth',2)

    set(gca,'FontSize',15)
    xlim(Tlims)
    ylim(Pthlims)
    ylabel('P_{th} (bpm)')

    % HR 
    subplot(3,2,3)
    hold on 
    plot(ones(2,1)*val_start,Hlims,'k--')
    plot(ones(2,1)*Tdata(i_t1),Hlims,'k--')
    plot(ones(2,1)*Tdata(i_t2),Hlims,'k:')
    plot(ones(2,1)*val_end,Hlims,'k--')
    plot(ones(2,1)*Tdata(i_t3),Hlims,'k--')
    plot(ones(2,1)*Tdata(i_t4),Hlims,'k--')
    plot(Tdata,Hdata,'b','linewidth',2)
    plot(Tdata,HR,'r','linewidth',2)
    
    set(gca,'FontSize',15)
    xlim(Tlims)
    ylim(Hlims)
    xlabel('Time (s)')
    ylabel('HR (bpm)')
    title('Nominal')
    
    subplot(3,2,4)
    hold on 
    plot(ones(2,1)*val_start,Hlims,'k--')
    plot(ones(2,1)*Tdata(i_t1),Hlims,'k--')
    plot(ones(2,1)*Tdata(i_t2),Hlims,'k:')
    plot(ones(2,1)*val_end,Hlims,'k--')
    plot(ones(2,1)*Tdata(i_t3),Hlims,'k--')
    plot(ones(2,1)*Tdata(i_t4),Hlims,'k--')
    plot(Tdata,Hdata,'b','linewidth',2)
    plot(Tdata,HR_LM,'r','linewidth',2)
    

    set(gca,'FontSize',15)
    xlim(Tlims)
    ylim(Hlims)
    xlabel('Time (s)')
    ylabel('HR (bpm)')
    title('Optimized')

    % Neural tones
    subplot(3,2,5)
    hold on 
    plot(ones(2,1)*val_start,2,'k--')
    plot(ones(2,1)*Tdata(i_t1),2,'k--')
    plot(ones(2,1)*Tdata(i_t2),2,'k:')
    plot(ones(2,1)*val_end,2,'k--')
    plot(ones(2,1)*Tdata(i_t3),2,'k--')
    plot(ones(2,1)*Tdata(i_t4),2,'k--')
    plot(Tdata,Tpb_LM,'color',[.5 0 .5],'linewidth',2) % purple parasympathetic
    plot(Tdata,Ts_LM,'color',[0 0.75 .75],'linewidth',2)  % slightly darker green than the 'g' command
    set(gca,'FontSize',15)
    xlim(Tlims)
    ylim([0 2])
    xlabel('Time (s)')
    ylabel('Outflow')
    
    subplot(3,2,6)
    hold on 
    plot(ones(2,1)*val_start,2,'k--')
    plot(ones(2,1)*Tdata(i_t1),2,'k--')
    plot(ones(2,1)*Tdata(i_t2),2,'k:')
    plot(ones(2,1)*val_end,2,'k--')
    plot(ones(2,1)*Tdata(i_t3),2,'k--')
    plot(ones(2,1)*Tdata(i_t4),2,'k--')
    plot(Tdata,Tpr_LM,'color',[1 .5 0],'linewidth',2)  % orange
    
    set(gca,'FontSize',15)
    xlim(Tlims)
    ylim([0 2])
    xlabel('Time (s)')
    ylabel('Outflow')
    
    fig_name = strcat('FIG9_',u{j});
    print(h,fig_name,'-dpng','-r400');
end 