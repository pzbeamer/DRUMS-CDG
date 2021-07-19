clear all
T=readtable('../Summary_Data_800_Gals/PatientInfo07132021.csv');
load('../Summary_Data_800_Gals/summary.mat','uniqueTimes');
pots_pats=cell(872,1);
oldcount=1;
newcount=1;
c=0;
p = 0;

for pt=3:872
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
            if uniqueTimes(2,pt-2)<30
                begin_avg_ind_a=1;
            else
                begin_avg_ind_a=find(abs(Tdata-(AS_start-30))==min(abs(Tdata-(AS_start-30))));
            end

            avg_HR_before_a=median(Hdata(begin_avg_ind_a:end_avg_ind_a));
            maxHR_a=max(movmean(Hdata(start_ind_a:end), 50));

            if (maxHR_a>=avg_HR_before_a+30 && T{pt,3}>19) || (maxHR_a>=avg_HR_before_a+40)
                disp(strcat(T{pt,1}," Meets Qualifications"));
                pots_pats(pt-2)=T{pt,1};
                newcount=newcount+1;

            end
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
            if uniqueTimes(1,pt-2)<60
                begin_avg_ind_h=1;
            else
                begin_avg_ind_h=find(abs(Tdata-(HUT_start-60))==min(abs(Tdata-(HUT_start-60))));
            end

            avg_HR_before_h=median(Hdata(begin_avg_ind_h:end_avg_ind_h));
            maxHR_h=max(movmean(Hdata(start_ind_h:end), 100));

            if (maxHR_h>=avg_HR_before_h+30 && T{pt,3}>19) || (maxHR_h>=avg_HR_before_h+40)
                disp(strcat(T{pt,1}," Meets Qualifications"));
                pots_pats(pt-2)=T{pt,1};
                newcount=newcount+1;
            end
        end
    end
    if oldcount~=newcount
        oldcount=newcount;
    end
    
    
    
end

save('potspats.mat','pots_pats');