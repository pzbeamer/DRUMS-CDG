clear all

T = readtable('PatientInfo07132021.csv','Headerlines',2);
for pt = 850:873
    pt_id = T{pt,1}{1}
  
    pt_file_name = strcat('/Volumes/GoogleDrive/Shared drives/REU shared/LSA/Vals_New/'...
               ,pt_id,'_val1_WS.mat');
    if isfile(pt_file_name)
        directory = '../../MatFiles/';
        copyfile(pt_file_name, directory)
    end
end