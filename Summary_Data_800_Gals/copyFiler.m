clear all
<<<<<<< HEAD
T = readtable('PatientInfo07082021.csv','Headerlines',2);
for pt = 250:500
=======
T = readtable('PatientInfo07132021.csv','Headerlines',2);
for pt = 1:250
>>>>>>> 09b192515a6d1d3e07b60432ff84b70d138842a8
    pt_id = T{pt,1}{1}
  
    pt_file_name = strcat('/Volumes/GoogleDrive/Shared drives/REU shared/LSA/Vals_New/'...
               ,pt_id,'_val1_WS.mat');
    if isfile(pt_file_name)
        directory = '../../Vals_New/';
        copyfile(pt_file_name, directory)
    end
end