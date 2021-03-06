clear all
T = readtable('../Summary_Data_800_Gals/PatientInfo062221.csv','Headerlines',2);
pts = 1;
ages = 3;
heights = 4;
weights = 5;
genders = 6;
beta2jas = 7;
beta2nejs = 8;
m2jas = 9;
m2nejs = 10;
NOPjas = 11;
NOPnejs = 12;
Starttimeofdatas = 13;
Notes = 14;
HUTrests = 15;
HUTstarts = 16;
HUTends = 17;
HUTNG = 18; %Change from previous table 2/14/21 - all below are +1
HUTnotes = 19;
ASrests = 20;
ASstarts = 21;
ASends = 22;
ASnotes = 23;


trackerMAT = cell(1,872,1);
load('../Summary_Data_800_Gals/summary.mat')

for pt=11
    pt
    pt_id = T{pt,1}{1};
    if isfile(strcat('/Volumes/GoogleDrive/.shortcut-targets-by-id/1Vnypyb_cIdCMJ49vzcg8V7cWblpVCeYZ/HPV_Data/MATLAB_Files/',pt_id,'.mat'))
        
        if lengths(1,pt-2) ~= 0 || lengths(2,pt-2)~=0
            
            load(strcat('/Volumes/GoogleDrive/.shortcut-targets-by-id/1Vnypyb_cIdCMJ49vzcg8V7cWblpVCeYZ/HPV_Data/MATLAB_Files/',pt_id,'.mat'),'dataend')
            
            AS_rest = 0;
            AS_start = 0;
            AS_end = 0;
            HUT_rest = 0;
            HUT_start = 0;
            HUT_end = 0;
            if ~isempty(T{pt,ASrests}{1})&& ~isempty(T{pt,ASends}{1})
                AS_rest = celltime_to_seconds(T{pt,ASrests});
                AS_start = celltime_to_seconds(T{pt,ASstarts});
                AS_end = celltime_to_seconds(T{pt,ASends});
            end
            if ~isempty(T{pt,HUTrests}{1})&& ~isempty(T{pt,HUTends}{1})
                HUT_rest = celltime_to_seconds(T{pt,HUTrests});
                HUT_start = celltime_to_seconds(T{pt,HUTstarts});
                HUT_end = celltime_to_seconds(T{pt,HUTends});
            end
            
            times = [AS_rest AS_start AS_end HUT_rest HUT_start HUT_end];
            badguy = dataend(1)/1000;
           
            
            
            for i = 1:length(times)
                
                if badguy < times(i) && times(i) > 0
                    trackerMAT{1,pt,1} = pt_id;
                    break
                end
            end
            
        end
    end
    


    
end
save ('badguys.mat','trackerMAT')

%% Show me bad guys
count = 0;
for i = 1:872
    if ~isempty(trackerMAT{1,i,1})
        disp(trackerMAT{1,i,1})
        count = count+1;
    end

end
count

