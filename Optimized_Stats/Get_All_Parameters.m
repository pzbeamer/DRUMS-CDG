

format shortg;
close all
T = readtable('../PatientInfo07192021.csv','Headerlines',2);

saveDat=0;

for pt= [6:872]


    pt_id = T{pt,1}{1}
    pt
    if isfile(strcat('../../Optimized/',pt_id,'_optimized.mat'))
        try
            clear saveDat;
            load(strcat('../../Optimized/',pt_id,'_optimized.mat'))
            %Parameters to estimate (taupb, taus, spb, spr, Hpr)
            INDMAP = saveDat.INDMAP;
            %Construct file to read
            pt_WS = strcat(pt_id,'_val1_WS.mat');
            %Load needed patient data
            data = load_data(pt_WS);
            data = TimeCut(data,[saveDat.restTime,30]);
            for k=1:8
                saveDat.optparsfull(k,:)=load_global_reverse(data,saveDat.optpars(k,:),INDMAP);
                saveDat.parsfull(k,:)=load_global_reverse(data,saveDat.pars(k,:),INDMAP);
            end
            save(strcat('../../Optimized/',pt_id,'_optimized.mat'),'saveDat')
        catch
        end
    end
end
        