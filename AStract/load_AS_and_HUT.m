load cell_of_HUT_and_AS.mat

exam_AS=0;
exam_HUT=1;


if exam_AS==1
    for ind=1:length(cell_of_AS)
        if isfile(strcat('/Volumes/GoogleDrive/Shared drives/REU shared/LSA/AS/',cell_of_AS{ind},'_AS_WS.mat'))
            load(strcat('/Volumes/GoogleDrive/Shared drives/REU shared/LSA/AS/',cell_of_AS{ind},'_AS_WS.mat'))
            %do things
        end
    end
end

if exam_HUT==1
    for ind=1:length(cell_of_HUT)
        if isfile(strcat('/Volumes/GoogleDrive/Shared drives/REU shared/LSA/HUT/',cell_of_HUT{ind},'_HUT_WS.mat'))
            load(strcat('/Volumes/GoogleDrive/Shared drives/REU shared/LSA/HUT/',cell_of_HUT{ind},'_HUT_WS.mat'))
            %do things
        end
    end
end    
    