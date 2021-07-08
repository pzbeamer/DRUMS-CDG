clear all
close all

T = readtable('PatientInfo07082021.csv','Headerlines',2);
alpha = zeros(1,869);



for pt = 3:684
   pt
   pt_id = T{pt,1}{1}
   
   for i = 1:4
       pt_file_name = strcat('/Volumes/GoogleDrive/Shared drives/REU shared/ForwardEvaluation/nomHRs/'...
               ,pt_id,'_val',num2str(i),'_nomHR.mat');
       if isfile(pt_file_name) 
          load(pt_file_name,'data')
          
          pressure = data.Pdata(data.i_t1:data.i_te);
          
          time = data.Tdata(data.i_t1:data.i_te);
          
          maximum = find(pressure == max(pressure));
          minimum = find(pressure == min(pressure));
          alpha(1,pt-3) = (pressure(maximum) - pressure(minimum))...
              /(time(maximum)-time(minimum)); 
           
       end 
   end
end

save('alpha.mat','alpha')