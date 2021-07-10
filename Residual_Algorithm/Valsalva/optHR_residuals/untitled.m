hold on
%         plot(Tdata,Hdata,'b','linewidth',4)
%         plot(Tdata,HR_LM,'r','linewidth',4)
%     
%         set(gca,'FontSize',15)
        
          plot(Tdata,Tpr_LM,'color',[1 .5 0],'linewidth',4)
          plot(Tdata,Tpb_LM,'color',[.5 0 .5],'linewidth',4) % purple parasympathetic
          ylim([0 2])
          plot(Tdata,Ts_LM,'color',[0 0.75 .75],'linewidth',4)  % slightly darker green than the 'g' command
          set(gca,'FontSize',15)
          xlim(Tlims)