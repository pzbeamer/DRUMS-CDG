clear all
close all

T = readtable('PatientInfo_063021.csv','Headerlines',2);
gammas = zeros(4,872);

for pt = 22:872
    pt_id = T{pt,1}{1};
    
    for i=1:4
        if isfile(strcat('/Volumes/GoogleDrive/Shared drives/REU shared/ForwardEvaluation/nomHRs/', pt_id, '_val', num2str(i),'_nomHR.mat'))
            load(strcat('/Volumes/GoogleDrive/Shared drives/REU shared/ForwardEvaluation/nomHRs/', pt_id, '_val', num2str(i),'_nomHR.mat'));
            gamma = max(data.Hdata(data.i_te:data.i_t3))/min(data.Hdata(data.i_t3:data.i_t4));
            gammas(i,pt) = gamma;
        end
    end
end
