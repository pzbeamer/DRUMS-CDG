
format shortg;
close all
T = readtable('../Residual_Algorithm/PatientInfo07212021.csv','Headerlines',2);
figureson = 1;
%for i = 1:4, 6:12;
    
%load(strcat('../../Control/Control_Optimized/control',num2str(i),'_optimized.mat'));

for pt = 15%3%:872;
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
            
            Sigs = DriverBasicME(data,INDMAP,saveDat.optpars,1,pt,figureson);
            
            pause
            
        end
     end
end
%end
        