%% No saveDat
T=readtable('../DRUMS-CDG/Cluster/Residual_Algorithm/PatientInfo07132021.csv');

ct=1;
%'HPV592_20150825_optimized.mat','HPV592_20151211_optimized.mat','HPV593_20160419_optimized.mat'
%pt = 654,655,656
%have no saveDat, suggesting major workspace issue/ spreadsheet
for pt=500:699
    pt_id=T{pt,1}{1};
    if isfile(strcat(pt_id,'_optimized.mat'))
        load(strcat(pt_id,'_optimized.mat'))
        try
            saveDat;
            clear saveDat;
        catch
            pt
            flags{1,ct}=pt_id;
            ct=ct+1;
        end
    end
end
    
%% Maximum Time Cutoff and Divergence
T=readtable('../DRUMS-CDG/Cluster/Residual_Algorithm/PatientInfo07132021.csv');

ct1=1;
ct2=1;
ct3=0;
ctfile=0;

%35 reach maximum time cutoff
%38 have divergence in optimal fits

for pt=[500:653 657:699]
    pt_id=T{pt,1}{1}
    if isfile(strcat(pt_id,'_optimized.mat'))
        ctfile=ctfile+1;
        load(strcat(pt_id,'_optimized.mat'))
        if saveDat.flag(1)==1
            flagBadErr{1,ct1}=pt_id;
            ct1=ct1+1;
        end
        if saveDat.flag(2)==1
            flagDiverge{1,ct2}=pt_id;
            ct2=ct2+1;
        end
        if saveDat.flag(1)==1 && saveDat.flag(2)==1
            ct3=ct3+1;
        end
    end
end

    

save ('flagDiverge.mat','flagDiverge')
save ('flagBadErr.mat','flagBadErr')