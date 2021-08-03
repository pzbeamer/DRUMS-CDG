
%index 30: fits are not too different, only one wayward optimization,
%median fine
format shortg;
close all
T = readtable('../Residual_Algorithm/PatientInfo07212021.csv','Headerlines',2);
figureson = 0;
Hfigure = 1;
%for i = 1:4, 6:12;
    
%load(strcat('../../Control/Control_Optimized/control',num2str(i),'_optimized.mat'));

for pt = 6%3%:872;
    pt_id = T{pt,1}{1}

     if isfile(strcat('../../Optimized/',pt_id,'_optimized.mat')) 
         clear flag
         clear saveDat.flag
            load(strcat('../../Optimized/',pt_id,'_optimized.mat'))
        if ~any(saveDat.flag) 
            %Parameters to estimate (taupb, taus, spb, spr, Hpr)
            INDMAP = saveDat.INDMAP;
            %Load needed patient data
            
            %WS = strcat('control',num2str(i),'_val1_WS.mat');
            WS = strcat('../MatFiles/',pt_id,'_val1_WS.mat');
            data = load_data(WS);
            data = TimeCut(data,[saveDat.restTime,30]);
            
            [Sigs,HR,time] = DriverBasicME(data,INDMAP,saveDat.optpars,1,pt,figureson);
            sstot = sum((data.Hdata-mean(data.Hdata)).^2);
            ssres = sum((data.Hdata-HR).^2);
            R2 = 1-ssres/sstot;
            rel_diff = norm(data.Hdata-HR)/norm(data.Hdata);
            if Hfigure
                figure(pt+1)
                plot(data.Tdata,data.Hdata,'b','linewidth',3)
                hold on
                plot(time,HR,'r','linewidth',3)
                title(strcat('R^2 = ',num2str(R2),', Rel diff = ',num2str(rel_diff)))
                set(gca,'fontsize',18)
                
            end
            
%             pause
            
        end
     end
end
%end
        