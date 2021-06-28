clear all
T=readtable('../Summary_Data_800_Gals/PatientInfo062221.csv');
load('../Summary_Data_800_Gals/summary.mat','betweenTimes');
hut_possibles=cell(872,1);
count=1;
c=0;

for pt=3:872
   
    T{pt,1}{1}
    if isfile(strcat('/Volumes/GoogleDrive/Shared drives/REU shared/LSA/HUT/',T{pt,1}{1},'_HUT_WS.mat'))
        disp("isfile");
        load(strcat('/Volumes/GoogleDrive/Shared drives/REU shared/LSA/HUT/',T{pt,1}{1},'_HUT_WS.mat'));
        c=c+1;
        %rest_ind=1;
        %end_ind=last index
        start_ind=find(abs(Tdata-HUT_start)==min(abs(Tdata-HUT_start)));
        end_avg_ind=find(abs(Tdata-(HUT_start-15))==min(abs(Tdata-(HUT_start-15))));
        if betweenTimes(1,pt-2)<60
            begin_avg_ind=1;
        else
            begin_avg_ind=find(abs(Tdata-(HUT_start-60))==min(abs(Tdata-(HUT_start-60))));
        end

        avg_HR_before=median(Hdata(begin_avg_ind:end_avg_ind));
        maxHR=max(movmean(Hdata(start_ind:end), 100));

        if (maxHR>=avg_HR_before+30 && T{pt,3}>19) || (maxHR>=avg_HR_before+40)
            disp(strcat(T{pt,1}," Meets Qualifications"));
            hut_possibles(count)=T{pt,1};
            count=count+1;
        end
    end
end