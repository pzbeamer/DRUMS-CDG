clear all
close all
format shortg
T=readtable('../Summary_Data_800_Gals/PatientInfo07192021.csv');
load('../Summary_Data_800_Gals/summary.mat','uniqueTimes');
pots_pats=cell(872,1);
oldcount=1;
newcount=1;
c=0;
p = 0;

<<<<<<< HEAD
=======

<<<<<<< HEAD
for pt=800:872
=======
>>>>>>> 4cc2055a06344306e82ce67a082f16b56edbffa0
for pt=3:30
>>>>>>> f48d97be3c111a041bc35af0135749842cae9f7d
    p = 0;
    T{pt,1}{1}
    if any(uniqueTimes(2,pt-2))
        c=c+1;
        p = 1;
         if isfile(strcat('/Volumes/GoogleDrive/Shared drives/REU shared/LSA/AS/',T{pt,1}{1},'_AS_WS.mat'));
            disp("isfile");
            
            load(strcat('/Volumes/GoogleDrive/Shared drives/REU shared/LSA/AS/',T{pt,1}{1},'_AS_WS.mat'));

            %rest_ind=1;
            %end_ind=last index
            start_ind_a=find(abs(Tdata-AS_start)==min(abs(Tdata-AS_start)));
            end_avg_ind_a=find(abs(Tdata-(AS_start-5))==min(abs(Tdata-(AS_start-5))));
            
            
            begin_avg_ind_a=find(abs(Tdata-(AS_start-AS_rest))==min(abs(Tdata-(AS_start-AS_rest))));
<<<<<<< HEAD
          
=======
            
<<<<<<< HEAD
            avg_HR_before_a=median(Hdata(begin_avg_ind_a:end_avg_ind_a));
            maxHR_a=max(movmean(Hdata(start_ind_a:end), 50));
            
            figure(pt-2)
            
            hold on
            plot(Tdata,Hdata,'linewidth',3)
            yline(avg_HR_before_a+30,'r','linewidth',3)
            xline(AS_start,'b')
=======


>>>>>>> 4cc2055a06344306e82ce67a082f16b56edbffa0
            avg_HR_before_a=median(Hdata(begin_avg_ind_a:end_avg_ind_a));
            maxHR_a=max(movmean(Hdata(start_ind_a:end), 50));
            
>>>>>>> f48d97be3c111a041bc35af0135749842cae9f7d


            

%             if (maxHR_a>=avg_HR_before_a+30 && T{pt,3}>19) || (maxHR_a>=avg_HR_before_a+40)
%                 disp(strcat(T{pt,1}," Meets Qualifications"));
%                 pots_pats(pt-2)=T{pt,1};
%                 newcount=newcount+1;
% 
%             end
        end
    end
    if any(uniqueTimes(1,pt-2))
        if p == 0
            c = c+1;
        end
        if isfile(strcat('/Volumes/GoogleDrive/Shared drives/REU shared/LSA/HUT/',T{pt,1}{1},'_HUT_WS.mat')) && oldcount==newcount 
            disp("isfile");
            load(strcat('/Volumes/GoogleDrive/Shared drives/REU shared/LSA/HUT/',T{pt,1}{1},'_HUT_WS.mat'));

            %rest_ind=1;
            %end_ind=last index
            start_ind_h=find(abs(Tdata-HUT_start)==min(abs(Tdata-HUT_start)));
            end_avg_ind_h=find(abs(Tdata-(HUT_start-15))==min(abs(Tdata-(HUT_start-15))));
            
            begin_avg_ind_h=find(abs(Tdata-(HUT_start-HUT_rest))==min(abs(Tdata-(HUT_start-HUT_rest))));
            

            avg_HR_before_h=median(Hdata(begin_avg_ind_h:end_avg_ind_h));
            maxHR_h=max(movmean(Hdata(start_ind_h:end), 100));
            
            
<<<<<<< HEAD
=======
            figure(pt)
            subplot(2,1,1)
            hold on
            plot(Tdata,Hdata,'linewidth',3)
            yline(avg_HR_before_a+30,'r','linewidth',3)
            xline(AS_start,'b')
            title('AS')
   
            subplot(2,1,2)
>>>>>>> f48d97be3c111a041bc35af0135749842cae9f7d
            hold on
            plot(Tdata,Hdata,'linewidth',3)
            yline(avg_HR_before_h+30,'r','linewidth',3)
            xline(HUT_start,'b')
<<<<<<< HEAD
=======
            title('HUT')
>>>>>>> f48d97be3c111a041bc35af0135749842cae9f7d

%             if (maxHR_h>=avg_HR_before_h+30 && T{pt,3}>19) || (maxHR_h>=avg_HR_before_h+40)
%                 disp(strcat(T{pt,1}," Meets Qualifications"));
%               
%                 pots_pats(pt-2)=T{pt,1};
%                 newcount=newcount+1;
%             end
        end
    end
%     if oldcount~=newcount
%         oldcount=newcount;
%     end
    
end

save('potspats.mat','pots_pats');