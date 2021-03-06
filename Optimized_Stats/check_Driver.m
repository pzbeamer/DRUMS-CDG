
%index 30: fits are not too different, only one wayward optimization,
%median fine
format shortg;
close all
T = readtable('../PatientInfo07192021.csv','Headerlines',2);

    
%for pt= 6:872 %[37 48 59 60 65 66 67]

%remove 1
%for 2 best error is best fit %in bad for med
%for 3 best fit is any but second, best error disproven % in bad for med
%remove 4, calibration during 
%5 fit wack but data seems fine ahhhh
%6 data is rough doesnt look like a valsalva, fits consistent though
%7 min error seems like best fit % in bad for med
%8 min error works
%9 min error works/median
%10 median works, realized im checking all things whoops
%11 median works
%14 is awful throw out was in bad for med
%15 awful was in bad for med throw out
%17 great data terrible fit????

%     index=4;
%     format shortg;
% 
%     load('../../Optimized_Stats/flagDiverge.mat');
%     pt_id=flagDiverge{index};
%     load(strcat('../../Optimized/',pt_id,'_optimized.mat'));
%     
%     %Parameters to estimate (taupb, taus, spb, spr, Hpr)
%     INDMAP = saveDat.INDMAP;
%     %Construct file to read
%     pt_WS = strcat(pt_id,'_val1_WS.mat');
%     %Load needed patient data
%     data = load_data(pt_WS);
%     data = TimeCut(data,[saveDat.restTime,30]);
%     %Run 7 additional optimizations with random nominal parameter values
%     for k = 1 %:8
%         DriverBasicME(data,INDMAP,saveDat.optpars,k);
%     end
%     pt_WS
%     pt_id = T{pt,1}{1}
%     pt

for i = 1:4, 6:12;
    
load(strcat('../../Control/Control_Optimized/control',num2str(i),'_optimized.mat'));

%     if isfile(strcat('../../Optimized/',pt_id,'_optimized.mat'))
            
        try
            %load(strcat('../../Optimized/',pt_id,'_optimized.mat'))

            %Parameters to estimate (taupb, taus, spb, spr, Hpr)
            INDMAP = saveDat.INDMAP;
            %Construct file to read
            pt_WS = strcat(pt_id,'_val1_WS.mat');
            %Load needed patient data
            data = load_data(pt_WS);
            data = TimeCut(data,[saveDat.restTime,30]);
            
            saveDat.symp=zeros(length(data.Hdata),8);
            saveDat.para=zeros(length(data.Hdata),8);
            %Run 7 additional optimizations with random nominal parameter values
            for k = 1:8
                Sigs=DriverBasicME(data,INDMAP,saveDat.optpars,k,pt);
                saveDat.symp(:,k)=Sigs(:,1);
                saveDat.para(:,k)=Sigs(:,2);
            end
            save(strcat('../../Optimized/',pt_id,'_optimized.mat'),'saveDat')
            clear saveDat;
        catch
        end
    end
%end
        