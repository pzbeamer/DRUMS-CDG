clear all
T=readtable('../Summary_Data_800_Gals/PatientInfo062221.csv');
load('../Summary_Data_800_Gals/summary.mat','betweenTimes');
pots_pats=cell(872,1);
oldcount=1;
newcount=1;
oldpat='HPV1';
c=0;

for pt=3:872
  % check if this patient is the same as the last patient
    newpat = 'HPV';
    ind = 4; %index
    ptname = T{pt,1}{1}; %patient number
    if ~strcmp(ptname(1),'H') %if the patient doesn't start with 'HPV', add it on
        ptname = strcat('HPV',ptname);
    end 
    addletters = ptname(ind); %letter to concatenate
       
    while ~isnan(str2double(addletters)) %go through each index of patname until you reach a non-number
        newpat = strcat(newpat, addletters);
        ind = ind+1;
        if ind <= strlength(ptname)
            addletters = ptname(ind);
        else
            addletters = '.'; %if the index is greater than the length of patname, break out of loop
        end    
    end

    
    T{pt,1}{1}
    if (isfile(strcat('/Volumes/GoogleDrive/Shared drives/REU shared/LSA/AS/',T{pt,1}{1},'_AS_WS.mat')) && ~strcmp(newpat,oldpat))
        disp("isfile");
        load(strcat('/Volumes/GoogleDrive/Shared drives/REU shared/LSA/AS/',T{pt,1}{1},'_AS_WS.mat'));
        c=c+1;
        %rest_ind=1;
        %end_ind=last index
        start_ind_a=find(abs(Tdata-AS_start)==min(abs(Tdata-AS_start)));
        end_avg_ind_a=find(abs(Tdata-(AS_start-5))==min(abs(Tdata-(AS_start-5))));
        if betweenTimes(2,pt-2)<30
            begin_avg_ind_a=1;
        else
            begin_avg_ind_a=find(abs(Tdata-(AS_start-30))==min(abs(Tdata-(AS_start-30))));
        end

        avg_HR_before_a=median(Hdata(begin_avg_ind_a:end_avg_ind_a));
        maxHR_a=max(movmean(Hdata(start_ind_a:end), 50));

        if (maxHR_a>=avg_HR_before_a+30 && T{pt,3}>19) || (maxHR_a>=avg_HR_before_a+40)
            disp(strcat(T{pt,1}," Meets Qualifications"));
            pots_pats(oldcount)=T{pt,1};
            newcount=newcount+1;
        end
    end

    if (isfile(strcat('/Volumes/GoogleDrive/Shared drives/REU shared/LSA/HUT/',T{pt,1}{1},'_HUT_WS.mat')) && oldcount==newcount && ~strcmp(newpat,oldpat))
        disp("isfile");
        load(strcat('/Volumes/GoogleDrive/Shared drives/REU shared/LSA/HUT/',T{pt,1}{1},'_HUT_WS.mat'));
        c=c+1;
        %rest_ind=1;
        %end_ind=last index
        start_ind_h=find(abs(Tdata-HUT_start)==min(abs(Tdata-HUT_start)));
        end_avg_ind_h=find(abs(Tdata-(HUT_start-15))==min(abs(Tdata-(HUT_start-15))));
        if betweenTimes(1,pt-2)<60
            begin_avg_ind_h=1;
        else
            begin_avg_ind_h=find(abs(Tdata-(HUT_start-60))==min(abs(Tdata-(HUT_start-60))));
        end

        avg_HR_before_h=median(Hdata(begin_avg_ind_h:end_avg_ind_h));
        maxHR_h=max(movmean(Hdata(start_ind_h:end), 100));

        if (maxHR_h>=avg_HR_before_h+30 && T{pt,3}>19) || (maxHR_h>=avg_HR_before_h+40)
            disp(strcat(T{pt,1}," Meets Qualifications"));
            pots_pats(oldcount)=T{pt,1};
            newcount=newcount+1;
        end
    end

    if (oldcount~=newcount && ~strcmp(newpat,oldpat))
        oldcount=newcount;
    end
    
    oldpat=newpat;
end