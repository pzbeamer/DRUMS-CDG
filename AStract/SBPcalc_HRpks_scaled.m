function [SPdata,pkprom] = SBPcalc_HRpks(Tdata,Pdata,Hdata,pkprom,graphsYoN,index,val_num,automate)
    %Determine SBP signal 
    %Pkprm := MinPeakProminence, usually 25 is good but may need to go lower
    %Run code with output graphs first to eyeball, then comment out. 
    %automate - do you want the algorithm to help determine a pkprom?
    graphs = graphsYoN; %0= no graphs, 1=with graphs
    
    maximum = max(Pdata);
    Pdata = Pdata/maximum;
    
   % pkprom=pkprom/maximum;

    dt = mean(diff(Tdata));
    
    flag = 1; %Start with flag = 1 %When to exit loop
    count = 0; %Inifinite loops are bad, can adjust max iterations
    max_iterations = 5;
    tol = .05; %Arbitrary, seems to work nicely though
    while flag == 1 && count <= max_iterations
%         [~,sbploc] = findpeaks(Pdata,'MinPeakDistance',round(.25/dt),'MinPeakProminence',pkprom); %Find pks in BP
        [~,sbploc] = findpeaks(Pdata,'MinPeakDistance',round(.25/dt),'MinPeakProminence',pkprom); %Find pks in BP
        if automate == 0
            break % If you don't want the algoritm the while loop breaks here
        end
        count = count+1;
        x = diff(Tdata(sbploc)); %Time between peaks
        y = 60./Hdata(sbploc(1:end-1)); %Predicted time between peaks per HR
        rel_dif = abs((x-y)./y); %Relative difference between projections. 
        %-2.*x.*y + (x.^2+2.*x.*y+y.^2)./2; %Projections onto line y = x, should be zero, if not then problems
        if mean(rel_dif)> tol
            ind = find(rel_dif == max(rel_dif)); %Take worst and fix it, then repeat
            if x(ind)>y(ind) %Larger gap in peaks than predicted by HR, need lower pkprom
                pkprom = 0.9*pkprom;
            elseif x(ind)<y(ind) %Detecting too many peaks, raise pkprom
                pkprom = 1.1*pkprom;
            else 
                disp('Something is wrong with SBPcalc_HRpks algorithm')
            end
        else
            flag = 0; %If nothing is wrong exit the algorithm via flag
        end
        
    end
    
    Pdata = Pdata*maximum;
    %pkprom = pkprom*maximum;
    T = [Tdata(1); Tdata(sbploc); Tdata(end)]; %includes first and last time point 
    P = [Pdata(sbploc(1)); Pdata(sbploc); Pdata(sbploc(end))];
    SP = griddedInterpolant(T,P,'pchip');
    SPdata = SP(Tdata); %Create SBP vector at Tdata time points
    

    if graphs == 1
        fig = figure%(index)
        clf
        
        hold on
      rectangle('Position',[153.8 60 1.2 100],'FaceColor',[.6 .6 .6])
      rectangle('Position',[155 60 12.8 100],'FaceColor',[.8 .8 .8])
      rectangle('Position',[167.8 60 1.2 100],'FaceColor',[.6 .6 .6])
      rectangle('Position',[169 60 16 100],'FaceColor',[.8 .8 .8])
        plot(Tdata,Pdata,'b')
        plot(Tdata,SPdata,'r','LineWidth',2)
      xline(160,'k--')
      xlim([140,200])
      title(strcat('i=',num2str(index),'val_num=',num2str(val_num)))
        set(gca,'fontsize',18)
        set(gca,'Fontsize',20)
        saveas(fig,strcat('figure20',num2str(val_num),'_pkprom.jpeg'));
    end


end 