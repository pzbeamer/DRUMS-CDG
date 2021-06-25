clear all
close all
%patient to read

load File_name_cell_06072021_short.mat   
q = [1 3 5 6 8 9 10 14 17 24 29 30];

for i=1:length(q)
    u{i} = strcat(cell_of_file_names{q(i),1}(1:end-9))
end

for j = 1:length(u)
    u{j};
    %optimizing
    pt_name = strcat(u{j},'_Val1_WS.mat'); 

    %parameters to optimize
    %INDMAP = [1 6 7 8 9 10 12 20 21]; %subset 1
    %INDMAP = [1 6 7 8 9 10 20 21]; %subset 2
    %INDMAP = [7 10 11 19 20 21]; %subset 3
    INDMAP = [1    5 6 7 8 9 10      12 13  20 21 ]; %subset 4
    
    
    %residual error vector
    error = zeros(5,2);

    for i = 0:4
        %call forward evaluation with 30-5*i second rest periods
        Func_DriverBasic_p(pt_name,[30 - 5*i 30]);
    
        nomHRfile =strcat('Valsalva/nomHR_residuals/',pt_name(1:end-7),'_',num2str(30-5*i),'_nomHR.mat');
        load(nomHRfile)
        %Call optimization with file generated by forward evaluation
        HR_LM = Func_DriverBasic_LM_p(nomHRfile,INDMAP);
    
        %calculate residual error
        start = find(Tdata == val_start);
        slut = find(Tdata == val_end);
        scaler = sqrt(length(Hdata(start:slut)))
        error(i+1,1) = norm((Hdata(start:slut)-HR_LM(start:slut))./Hdata(start:slut)/scaler);
        error(i+1,2) = (max(Hdata(start:slut)) - max(HR_LM(start:slut)))/max(Hdata(start:slut));
        
        if error(i+1,1) < .8/scaler || error(i+1,2) < 5/max(Hdata(start:slut))
             break
        end
        
        
        
    end
    %plots
        clear h
        load(strcat('Valsalva/nomHR_residuals/',u{j},'_Val1_',num2str(30 - 5*i),'_nomHR.mat'))
        load(strcat('Valsalva/optHR_residuals/',u{j},'_Val1_',num2str(30 - 5*i),'_optHRsub4.mat'))
    
        h = figure(j+1);
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
        
        hold off

        fig_name = strcat('sub4FIG_',u{j},'_',num2str(30 - 5*i));
        print(h,fig_name,'-dpng','-r400');
end
%identify which rest length did the best
%saveas(figure(i+1),strcat('Figures/',pt_name(1:end-7),'_bestRest.jpeg'))

