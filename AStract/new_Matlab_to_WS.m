clear all
T = readtable('../Summary_Data_800_Gals/PatientInfo062221.csv','Headerlines',2);
% Td = readtable('../HPV_demographic_info_2_9_21.csv'); %THIS WILL PRODUCE WARNINGS BUT IT'S FINE d = demographics
% HPV_numbers = Td.HPV_nummer;
% Ages = Td.Alder;
% Sexes = zeros(length(Ages),1); 
% for i = 1:length(Ages)
%     if ~isempty(Td.Male_(i))
%         Sexes(i) = 1;
%     end
% end

%% Column Numbers
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

%% Other Variables
max_HPV_num = 419; % will change for all values
rtas = 180; %desired rest time for AS
rthut = 270; %desired rest time for HUT

%% Load In Matlab Files
%Pressure data negative at index 50, cause of failure?
%some HR data is nan at index 113, cause of failure?
%same HR sitch at index 135
for pt=136:419;
    pt_id = T{pt,1}{1}
    if isfile(strcat('/Volumes/GoogleDrive/.shortcut-targets-by-id/1Vnypyb_cIdCMJ49vzcg8V7cWblpVCeYZ/HPV_Data/MATLAB_Files/',pt_id,'.mat'))
        load(strcat('/Volumes/GoogleDrive/.shortcut-targets-by-id/1Vnypyb_cIdCMJ49vzcg8V7cWblpVCeYZ/HPV_Data/MATLAB_Files/',pt_id,'.mat'))
        start_time_of_file = 0;
        automatically_match_channels = 1;



        if automatically_match_channels == 1
            channels = ['EKG            ';'Hjertefrekvens ';'Blodtryk finger'];
            channel_inds = zeros(3,1);
            for j = 1:size(channels,1)
                for k = 1:size(titles,1)
                    if min(channels(j,:) == titles(k,:)) == 1
                        channel_inds(j) = k;
                    end
                end
            end
            if min(channel_inds) == 0
                error('Unable to automatically match channels - match manually')
            end
        else
            channel_inds = [1,2,3]; %Put in indecies for channels for EKG, HR, BP
            %Position in channel_inds is what column in dat you want it to be
            %Number is what column it is in the data from labchart
        end


        %Assemble data
        %ttt=T{pt,Starttimeofdatas}
        %tstart = str2double(T{pt,Starttimeofdatas}{1});
        %tstart=celltime_to_seconds(T{pt,Starttimeofdatas});
        tstart=0;
        if isnumeric(tstart) %If tstart is a number don't do anything
        elseif isnan(str2double(T{pt,Starttimeofdatas}{1})) && isempty(str2double(T{pt,Starttimeofdatas}{1}))
            tstart = 0; %Assume if nothing is written then start time is 0
        elseif isnan(str2double(T{pt,Starttimeofdatas}{1}))
            error(strcat('Not numerical input for tstart, check index i = ',num2str(pt)))
        else
            error(strcat('Undefined error concerning tstart, check index i = ',num2str(pt)))
        end

        dat = zeros(dataend(1),4);
        if length(tickrate) ~= 1
            if mean(tickrate) == tickrate(1)
                tickrate = tickrate(1);
            else
                error(strcat('Check tickrate - something strange. Index ',num2str(pt)))
            end
        end

        dummy_time_vec= tstart:1/tickrate:dataend(1)/tickrate-1/tickrate;
        dat(:,1) = dummy_time_vec+start_time_of_file;
        for j = 1:length(channel_inds)
            dat(:,j+1) = data(datastart(channel_inds(j)):dataend(channel_inds(j))); %i+1 b/c time in column 1
        end
        t = dat(:,1);


        Age = T{pt,ages};
        Sex = T{pt,genders};


        %% ---- AS ----

        if ~isempty(T{pt,ASrests}{1})
            AS_rest = celltime_to_seconds(T{pt,ASrests});
            AS_start = celltime_to_seconds(T{pt,ASstarts});
            AS_end = celltime_to_seconds(T{pt,ASends});
            AS_times = [AS_rest,AS_end];
            AS_inds = zeros(1,length(AS_times));
            for j = 1:length(AS_inds)
                AS_inds(j) = find(abs(t-AS_times(j)) == min(abs(t-AS_times(j))));
            end
            if AS_inds(1)==AS_inds(2)
                strcat('Error with ',pt_id)
                return
            end
            AS_s = AS_inds(1):AS_inds(2);
            AS_dat = dat(AS_s,:);

            s = (1:100:length(AS_dat(:,1)))'; %Sampling vector 2.5 Hz
            %Calculate needed quantities before you subsample down
            pkprom = 25.*ones(max_HPV_num,1);
            SPdata_not_sampled = SBPcalc_HRpks(AS_dat(:,1),AS_dat(:,4),AS_dat(:,3),pkprom(pt),0,pt,1,1);
            SPdata = SPdata_not_sampled(s);
            sdat = AS_dat(s,:);
            Tdata = sdat(:,1);
            ECG = sdat(:,2);
            Hdata = sdat(:,3);
            Pdata = sdat(:,4);
            ASrestind = find(abs(Tdata-AS_rest) == min(abs(Tdata-AS_rest)));
            ASendind = find(abs(Tdata-AS_end) == min(abs(Tdata-AS_end)));
            ASstartind = find(abs(Tdata-AS_start) == min(abs(Tdata-AS_start)));

            flag = 0;
            if Tdata(ASstartind)-Tdata(ASrestind)<rtas
                flag = 1;
            end

        end

        notes = T{pt,ASnotes};
        if ~isempty(notes)
            disp(strcat('There are AS notes for i=',num2str(pt)))
        end
        if flag>0
            disp(strcat('AS rest time does not meet desired for i=',num2str(pt)))
        end

        cell_row_for_pt=T(pt,:);
        save_workspace = 1;


        if save_workspace == 1
            save(strcat('/Volumes/GoogleDrive/Shared drives/REU shared/LSA/AS/',T{pt,1}{1}(1:end-9),'_AS_WS.mat'),... %Name of file
                 'Age','ECG','Hdata','Pdata','Sex','SPdata','Tdata','flag',...
                 'AS_rest','AS_start','AS_end','notes','cell_row_for_pt') %Variables to save
        end


           %% ---- HUT ----

        if ~isempty(T{pt,HUTrests}{1})
            HUT_rest = celltime_to_seconds(T{pt,HUTrests});
            HUT_start = celltime_to_seconds(T{pt,HUTstarts});
            HUT_end = celltime_to_seconds(T{pt,HUTends});
            HUT_times = [HUT_rest,HUT_end];
            HUT_inds = zeros(1,length(HUT_times));
            for j = 1:length(HUT_inds)
                    find(abs(t-HUT_times(j)) == min(abs(t-HUT_times(j))));
                    HUT_inds(j) = find(abs(t-HUT_times(j)) == min(abs(t-HUT_times(j))));
            end

            HUT_s = HUT_inds(1):HUT_inds(2);
            HUT_dat = dat(HUT_s,:);

            s = (1:100:length(HUT_dat(:,1)))'; %Sampling vector 2.5 Hz
            %Calculate needed quantities before you subsample down
            pkprom = 25.*ones(max_HPV_num,1);
            SPdata_not_sampled = SBPcalc_HRpks(HUT_dat(:,1),HUT_dat(:,4),HUT_dat(:,3),pkprom(pt),0,pt,1,1);
            SPdata = SPdata_not_sampled(s);
            sdat = HUT_dat(s,:);
            Tdata = sdat(:,1);
            ECG = sdat(:,2);
            Hdata = sdat(:,3);
            Pdata = sdat(:,4);
            HUTrestind = find(abs(Tdata-HUT_rest) == min(abs(Tdata-HUT_rest)));
            HUTendind = find(abs(Tdata-HUT_end) == min(abs(Tdata-HUT_end)));
            HUTstartind = find(abs(Tdata-HUT_start) == min(abs(Tdata-HUT_start)));

            flag = 0;
            if Tdata(HUTstartind)-Tdata(HUTrestind)<rthut
                flag = 1;
            end

        end

        notes = T{pt,HUTnotes};
        if ~isempty(notes)
            disp(strcat('There are HUT notes for i=',num2str(pt)))
        end
        if flag>0
            disp(strcat('HUT rest time is less than desired for i=',num2str(pt)))
        end

        cell_row_for_pt=T(pt,:);
        save_workspace = 1;


        if save_workspace == 1
            save(strcat('/Volumes/GoogleDrive/Shared drives/REU shared/LSA/HUT/',T{pt,1}{1}(1:end-9),'_HUT_WS.mat'),... %Name of file
                 'Age','ECG','Hdata','Pdata','Sex','SPdata','Tdata','flag',...
                 'HUT_rest','HUT_start','HUT_end','notes','cell_row_for_pt') %Variables to save
        end


    end
end

%% Subfunctions
function [time_in_seconds] = celltime_to_seconds(cell_with_string_time)
    t = cell_with_string_time{1};
    
    if sum(t == '.') == 0 %Make sure there is a .0 at the end
        t = strcat(t,'.0');
    end
    
    len = length(t);
    
    if len >= 3
        if t(end-2) == '.' %Gaurd against the auto formating of .00 instead of .0
            t = t(1:end-1);
        end
    end
    
    if sum(t == '.') ~=0 && sum(t == ':') ~=0
        c_ind = find(t==':');
        p_ind = find(t=='.');
        if p_ind - c_ind == 2 %Gaurd against 34:6.0 instead of 34:06.0
            t = strcat(t(1:c_ind),'0',t(p_ind-1:end));
        end 
    end
    
    
        
            
    
    
    if len >= 9 %Hours max
        hour = str2double(t(1:end-8));
        min = str2double(t(end-6:end-5));
        second = str2double(t(end-3:end));
    elseif len >= 6 %Minutes max
        hour = 0;
        min = str2double(t(1:end-5));
        second = str2double(t(end-3:end));
    elseif len >= 3 %Seconds max
        hour = 0;
        min = 0;
        second = str2double(t(1:end));
    end
    
    time_in_seconds = hour*60*60 + min*60 + second;
    

end
