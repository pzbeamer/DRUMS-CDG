clear all
close all

T = readtable('../Summary_data_800_Gals/PatientInfo07132021.csv','Headerlines',2);
alpha = zeros(1,869);
negatives = cell(3,869);

%Thank you Sophie!!
for pt = 679
   pt
   pt_id = T{pt,1}{1}
   
   for i = 1
       pt_file_name = strcat('/Volumes/GoogleDrive/Shared drives/REU shared/ForwardEvaluation/nomHRs/'...
               ,pt_id,'_val',num2str(i),'_nomHR.mat');
       if isfile(pt_file_name)
           load(pt_file_name,'data')
           inds=min(find(data.Tdata>=data.val_start));
           inde=min(find(data.Tdata>=data.val_end));
           plot(data.Tdata(inds:inde),data.Pdata(inds:inde));
       end
   end
end