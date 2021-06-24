clear all
T=readtable('../Summary_Data_800_Gals/PatientInfo062221.csv');
c=1;


for pt=3:872
    if isfile(strcat('/Volumes/GoogleDrive/.shortcut-targets-by-id/1Vnypyb_cIdCMJ49vzcg8V7cWblpVCeYZ/HPV_Data/MATLAB_Files/',T{pt,1}{1},'.mat'))
        c=c+1;
    end
end