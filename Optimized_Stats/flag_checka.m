%% No saveDat
<<<<<<< HEAD
T=readtable('../Summary_Data_800_Gals/PatientInfo07132021.csv');
=======
T=readtable('../Cluster/Residual_Algorithm/PatientInfo07132021.csv');
>>>>>>> 0f5bcc80e946f800f64e686ae9fafb22c7caddd1

ct=0;
%'HPV592_20150825_optimized.mat','HPV592_20151211_optimized.mat','HPV593_20160419_optimized.mat'
%pt = 654,655,656
%have no saveDat, suggesting major workspace issue/ spreadsheet
<<<<<<< HEAD
for pt=250:500
    pt_id=T{pt,1}{1};
    if isfile(strcat('../../Optimized/',pt_id,'_optimized.mat'))
        load(strcat('../../Optimized/',pt_id,'_optimized.mat'))
=======
for pt=3:250
    pt_id=T{pt,1}{1};
    if isfile(strcat('../Optimized/',pt_id,'_optimized.mat'))
        load(strcat('../Optimized/',pt_id,'_optimized.mat'))
>>>>>>> 0f5bcc80e946f800f64e686ae9fafb22c7caddd1
        try
            saveDat;
            clear saveDat;
        catch
            pt
            flags{1,ct+1}=pt_id;
            ct=ct+1;
        end
    end
end
    
%% Maximum Time Cutoff and Divergence
<<<<<<< HEAD
%T=readtable('../DRUMS-CDG/Cluster/Residual_Algorithm/PatientInfo07132021.csv');
=======
T=readtable('../Cluster/Residual_Algorithm/PatientInfo07132021.csv');
>>>>>>> 0f5bcc80e946f800f64e686ae9fafb22c7caddd1

ct1=0;
ct2=0;
ct3=0;
ctfile=0;

%35 reach maximum time cutoff
%38 have divergence in optimal fits

<<<<<<< HEAD
for pt=250:500
    pt_id=T{pt,1}{1}
    if isfile(strcat('../../Optimized/',pt_id,'_optimized.mat'))
        ctfile=ctfile+1;
        load(strcat('../../Optimized/',pt_id,'_optimized.mat'))
=======
for pt=[3:250]
    pt_id=T{pt,1}{1}
    if isfile(strcat('../Optimized/',pt_id,'_optimized.mat'))
        ctfile=ctfile+1;
        load(strcat('../Optimized/',pt_id,'_optimized.mat'))
>>>>>>> 0f5bcc80e946f800f64e686ae9fafb22c7caddd1
        if saveDat.flag(1)==1
            flagBadErr{1,ct1+1}=pt_id;
            ct1=ct1+1;
        end
        if saveDat.flag(2)==1
            flagDiverge{1,ct2+1}=pt_id;
            ct2=ct2+1;
        end
        if saveDat.flag(1)==1 && saveDat.flag(2)==1
            ct3=ct3+1;
        end
    end
end

save ('flagDiverge.mat','flagDiverge')
save ('flagBadErr.mat','flagBadErr')