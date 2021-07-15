clear all

T = readtable('PatientInfo07132021.csv','Headerlines',2);
<<<<<<< HEAD
for pt = 550:699
    pt
=======
for pt = 850:873
>>>>>>> f55bb8c0753b176a8e42778bd2e80d51b2a54da1
    pt_id = T{pt,1}{1}
  
    pt_file_name = strcat('/Volumes/GoogleDrive/Shared drives/REU shared/LSA/Vals_New/'...
               ,pt_id,'_val1_WS.mat');
<<<<<<< HEAD
    if isfile(pt_file_name) && ~isfile(strcat('../../Valsalvas4Opt/',pt_id,'val1_WS.mat'))
        directory = '../../Valsalvas4Opt/';
=======
    if isfile(pt_file_name)
        directory = '../../MatFiles/';
>>>>>>> f55bb8c0753b176a8e42778bd2e80d51b2a54da1
        copyfile(pt_file_name, directory)
    end
end