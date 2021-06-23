clear all

load('/Volumes/GoogleDrive/Shared drives/REU shared/LSA/AS/HPV2_20131022_AS_WS.mat');

%rest_ind=1;
%end_ind=last index
start_ind=find(abs(Tdata-AS_start)==min(abs(Tdata-AS_start)));
begin_avg_ind=find(abs(Tdata-AS_start-30)==min(abs(Tdata-AS_start-30)));

avg_HR_before=mean(Hdata(start_ind:begin_avg_ind));
maxHR=max(Hdata(start_ind:end));

if maxHR>=avg_HR_before+30
    disp("Meets Qualifications");
end