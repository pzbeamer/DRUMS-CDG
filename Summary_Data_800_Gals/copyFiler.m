clear all

T = readtable('PatientInfo07212021.csv','Headerlines',2);

for pt = 3:872
    pt_id = T{pt,1}{1}
  
    pt_file_name = strcat('/Volumes/GoogleDrive/Shared drives/REU shared/LSA/Vals_New/'...
               ,pt_id,'_val2_WS.mat');
   
    if isfile(pt_file_name)
        directory = '../Cluster/MatFiles/';
        copyfile(pt_file_name, directory)
    end
end