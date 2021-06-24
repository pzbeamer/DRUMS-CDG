clear all
T=readtable('../Summary_Data_800_Gals/PatientInfo062221.csv');
load('../Summary_Data_800_Gals/summary.mat','betweenTimes');
pots_possibles=cell(872,1);
count=1;
c=0;

for pt=3:872
   
    T{pt,1}{1}
    if isfile(strcat('/Volumes/GoogleDrive/Shared drives/REU shared/LSA/AS/',T{pt,1}{1},'_AS_WS.mat'))
        disp("isfile");
        load(strcat('/Volumes/GoogleDrive/Shared drives/REU shared/LSA/AS/',T{pt,1}{1},'_AS_WS.mat'));
        c=c+1;
        %rest_ind=1;
        %end_ind=last index
        start_ind=find(abs(Tdata-AS_start)==min(abs(Tdata-AS_start)));
        end_avg_ind=find(abs(Tdata-(AS_start-5))==min(abs(Tdata-(AS_start-5))));
        if betweenTimes(2,pt-2)<30
            begin_avg_ind=1;
        else
            begin_avg_ind=find(abs(Tdata-(AS_start-30))==min(abs(Tdata-(AS_start-30))));
        end

        avg_HR_before=mean(Hdata(begin_avg_ind:end_avg_ind));
        maxHR=max(movmean(Hdata(start_ind:end),50));

        if (maxHR>=avg_HR_before+30 && T{pt,3}>19) || (maxHR>=avg_HR_before+40)
            disp(strcat(T{pt,1}," Meets Qualifications"));
            pots_possibles(count)=T{pt,1};
            count=count+1;
        end
    end
end