function [SPdata,pkprom] = SBPcalc_HRpks_windows(Tdata,Pdata,Hdata,pkprom,graphsYoN,index,val_num,automate)
    %Determine SBP signal 
    %Pkprm := MinPeakProminence, usually 25 is good but may need to go lower
    %Run code with output graphs first to eyeball, then comment out. 
    %automate - do you want the algorithm to help determine a pkprom?
    
    %P = zeros(length(Pdata)/50,50);
    P = [];
    %T = zeros(length(Tdata)/50,50);
    T = [];
    pkproms = [];
    graphs = graphsYoN; %0= no graphs, 1=with graphs
    stop = ceil(length(Pdata)/100)*100; 

    for i=100:100:stop
        
        if i==stop
            break
            Pdata_cut=Pdata(i-mod(i,100):i);
            if length(Pdata_cut)==2
                break
            end
            Tdata_cut=Tdata(i-mod(i,100):i);
            Hdata_cut=Hdata(i-mod(i,100):i);
        else
            Pdata_cut=Pdata(i-99:i);
            Tdata_cut=Tdata(i-99:i);
            Hdata_cut=Hdata(i-99:i);
        end

        dt=mean(diff(Tdata_cut));

        flag = 1; %Start with flag = 1 %When to exit loop
        count = 0; %Inifinite loops are bad, can adjust max iterations
        max_iterations = 5;
        tol = .01; %Arbitrary, seems to work nicely though
        while flag == 1 && count <= max_iterations
            %round(.001/dt)
            pk_cut = abs(pkprom-(Pdata_cut(1)-Pdata(1)));
            [~,sbploc] = findpeaks(Pdata_cut,'MinPeakDistance',round(.01/dt),'MinPeakProminence',pk_cut); %Find pks in BP
            if automate == 0
                break % If you don't want the algoritm the while loop breaks here
            end
            count = count+1;
            x = diff(Tdata_cut(sbploc)); %Time between peaks
            y = 60./Hdata_cut(sbploc(1:end-1)); %Predicted time between peaks per HR
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
        pkproms = [pkproms pkprom];
        %P(ind,:) = Pdata_cut(sbploc);
        P = [P Pdata_cut(sbploc)'];
        %T(ind,:) = Tdata_cut(sbploc);
        T = [T Tdata_cut(sbploc)'];
    end

    %T = [Tdata(1); T; Tdata(end)]; %includes first and last time point 

    %P = [P(1,1); P; P(end,end)];
    SP = griddedInterpolant(T,P,'pchip');
    SPdata = SP(Tdata); %Create SBP vector at Tdata time points
    
    

    if graphs == 1
        fig = figure%(index)
        clf
        
        hold on
     % rectangle('Position',[153.8 60 1.2 100],'FaceColor',[.6 .6 .6])
     % rectangle('Position',[155 60 12.8 100],'FaceColor',[.8 .8 .8])
     % rectangle('Position',[167.8 60 1.2 100],'FaceColor',[.6 .6 .6])
     % rectangle('Position',[169 60 16 100],'FaceColor',[.8 .8 .8])
        plot(Tdata,Pdata,'b')
        plot(T,P,'o');
        plot(Tdata,SPdata,'m');
      %xline(160,'k--')
      %xlim([140,200])
      %title(strcat('i=',num2str(index),'val_num=',num2str(val_num)))
      %  set(gca,'fontsize',18)
      %  set(gca,'Fontsize',20)
      %  saveas(fig,strcat('figure20',num2str(val_num),'_pkprom.jpeg'));
    end


end 