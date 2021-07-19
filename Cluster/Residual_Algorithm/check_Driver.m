%index 30: fits are not too different, only one wayward optimization,
%median fine
format shortg;

T = readtable('../PatientInfo07132021.csv','Headerlines',2);

    
        for pt= 23%[37 48 59 60 65 66 67]

            pt_id = T{pt,1}{1}
            pt
            
%             load('../../../Optimized/flagDiverge.mat')
%             pt_id=flagDiverge{index};
            if isfile(strcat('../../Optimized/',pt_id,'_optimized.mat'))
            load(strcat('../../Optimized/',pt_id,'_optimized.mat'))
            
            %Parameters to estimate (taupb, taus, spb, spr, Hpr)
            INDMAP = saveDat.INDMAP;
            %Construct file to read
            pt_WS = strcat(pt_id,'_val1_WS.mat');
            %Load needed patient data
            data = load_data(pt_WS);
            data = TimeCut(data,[saveDat.restTime,30]);
            %Run 7 additional optimizations with random nominal parameter values
        for k = 1:2%1:8
        DriverBasicME(data,INDMAP,saveDat.optpars,k,pt);
        end
            end
        end
        