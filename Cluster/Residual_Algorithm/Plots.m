
%index 30: fits are not too different, only one wayward optimization,
%median fine
format shortg;
close all
T = readtable('../PatientInfo07192021.csv','Headerlines',2);

for i = 1:4, 6:12;
    
load(strcat('../../Control/Control_Optimized/control',num2str(i),'_optimized.mat'));

%     if isfile(strcat('../../Optimized/',pt_id,'_optimized.mat'))
            
            %load(strcat('../../Optimized/',pt_id,'_optimized.mat'))

            %Parameters to estimate (taupb, taus, spb, spr, Hpr)
            INDMAP = saveDat.INDMAP;
            %Load needed patient data
            
            WS = strcat('control',num2str(i),'_val1_WS.mat');
           
            data = load_data(WS);
            data = TimeCut(data,[saveDat.restTime,30]);
            
            Sigs = DriverBasicME(data,INDMAP,saveDat.optpars,1,i);
            
        
end
%end
        