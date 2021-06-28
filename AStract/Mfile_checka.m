clear all
T=readtable('../Summary_Data_800_Gals/PatientInfo062221.csv');
load('../Summary_Data_800_Gals/summary.mat','betweenTimes');
c=1;
d=1;
ce = cell(872,1);

for pt=3:872
    if isfile(strcat('/Volumes/GoogleDrive/.shortcut-targets-by-id/1Vnypyb_cIdCMJ49vzcg8V7cWblpVCeYZ/HPV_Data/MATLAB_Files/',T{pt,1}{1},'.mat'))
        c=c+1;
    elseif any(betweenTimes(:,pt-2),'all')
        ce{d}= T{pt,1}{1};
        d=d+1;
    end
end

ce