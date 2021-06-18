clear
% T = readtable('PatientInfo.xlsx - Sheet1_12222020_111.csv','Headerlines',2);
T = readtable('PatientInfo061421.xlsx-Sheet1.csv','Headerlines',2);
% T(1:6,:)

%% Column numbers
% Load in table and manipulate it to be useful
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
DBrests = 24; %Deep breathing 
DBstarts = 25;
DBends = 26;
DBnotes = 27;
Vals = [28:32;33:37;38:42;43:47]; %Each row a new val, cols rest, start, end,rest end, notes
% Val1rests = 26;
% Val1starts = 27;
% Val1ends = 28;
% Val1restends = 29;
% Val1notes = 30;
% Val2rests = 31;
% Val2starts = 32;
% Val2ends = 33;
% Val2restends = 34;
% Val2notes = 35;
% Val3rests = 36;
% Val3starts = 37;
% Val3ends = 38;
% Val3restends = 39;
% Val3notes = 40;
% Val4rests = 41;
% Val4starts = 42;
% Val4ends = 43;
% Val4restends = 44;
% Val4notes = 45;
% % cuff = zeros(11,4); Sheet is currently messed up - need pulse in each
% cuff spot - fix later and be careful
% % for i = 1:12
% %     cuff(i,:) = 43+4*i:46+4*i;
% % end

%% Which files are missing?
check_missing_files = 1;
if check_missing_files == 1
    count = 1;
    clear missing_files
    for pt = 6:30
        pt_id = T{pt,1}{1};
        if ~isfile(strcat('../MATLAB_Files/',pt_id,'.mat'))
            missing_files{count} = pt_id;
            count = count+1;
        end
    end
    missing_files
end
        

%% Load file and assemble data 

% HPV_num = 222;
% load(strcat('HPV',num2str(HPV_num),'.mat'))
ALL_WRITE = 1; %Write all of the files

%FILE NOTES
%pt = 131 unconcios but note is in wrong spot
%pt = 174 are all start times after this 0?
%formating gets weird around 500
%pt = 215 Val2 time is /4?
%pt = 249 & 250 - misplaced cuff info? Moved
%pt = 284 - Val time has notes in it
%pt = 311 - AS - .o instead of .0
%pt = 435 - AS Down is /6
 
for pt = 6:92%500:500 %Done through 500  %6:92 are indices 20 through 45
%     load('HPV3_20151209.mat')
    pt_id = T{pt,1}{1};
    if isfile(strcat('../MATLAB_Files/',pt_id,'.mat'))
        load(strcat('../MATLAB_Files/',pt_id,'.mat'))
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
        tstart = str2double(T{pt,Starttimeofdatas}{1});
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


    %% ---- HUT ----
        write_HUT = 0;

        if ~isempty(T{pt,HUTrests}{1})
            HUT_start = celltime_to_seconds(T{pt,HUTrests});
            HUT_end = celltime_to_seconds(T{pt,HUTends});
            HUT_times = [HUT_start,HUT_end];
            HUT_inds = zeros(1,length(HUT_times));
            for j = 1:length(HUT_inds)
                    HUT_inds(j) = find(abs(t-HUT_times(j)) == min(abs(t-HUT_times(j))));
            end
            HUT_s = HUT_inds(1):HUT_inds(2);
            HUT_dat = dat(HUT_s,:);

            if write_HUT == 1 || ALL_WRITE == 1
                disp('g');
                writematrix(HUT_dat,strcat('HUT/',pt_id,'_HUT.txt'))
            end
        end

    %% ---- AS ----
        write_AS = 1;

        if ~isempty(T{pt,ASrests}{1})
            AS_start = celltime_to_seconds(T{pt,ASrests});
            AS_end = celltime_to_seconds(T{pt,ASends});
            AS_times = [AS_start,AS_end];
            AS_inds = zeros(1,length(AS_times));
            for j = 1:length(AS_inds)
                AS_inds(j) = find(abs(t-AS_times(j)) == min(abs(t-AS_times(j))));
            end
            AS_s = AS_inds(1):AS_inds(2);
            AS_dat = dat(AS_s,:);

            if write_AS == 1 || ALL_WRITE == 1
                writematrix(AS_dat,strcat('AS/',pt_id,'_AS.txt'))
            end
        end


    %% ---- Deep breathing (DB) ----
        write_DB = 1;

        if ~isempty(T{pt,DBrests}{1})
            DB_start = celltime_to_seconds(T{pt,DBrests});
            DB_end = celltime_to_seconds(T{pt,DBends});
            DB_times = [DB_start,DB_end];
            DB_inds = zeros(1,length(DB_times));
            for j = 1:length(DB_inds)
                DB_inds(j) = find(abs(t-DB_times(j)) == min(abs(t-DB_times(j))));
            end
            DB_s = DB_inds(1):DB_inds(2);
            DB_dat = dat(DB_s,:);

            if write_DB == 1 || ALL_WRITE == 1
                writematrix(DB_dat,strcat('Deep_Breathing/',pt_id,'_DB.txt'))
            end
        end

    %% ---- Valsalva ----
       write_val = 1;

        % How many Valsavas?
        val_check = zeros(1,4);
        for i = 1:4
            val_check(i) = ~isempty(T{pt,Vals(i,1)}{1});
        end
        num_of_vals = sum(val_check);

        %Extract data
        if num_of_vals > 0
            for i = find(val_check == 1)%1:num_of_vals 
                val_start = celltime_to_seconds(T{pt,Vals(i,1)});
                val_end = celltime_to_seconds(T{pt,Vals(i,4)});
                val_times = [val_start,val_end]; %Rest start and Rest end
                val_inds = zeros(1,length(val_times));
                for j = 1:length(val_inds)
                    val_inds(j) = find(abs(t-val_times(j)) == min(abs(t-val_times(j))));
                end
                val_s = val_inds(1):val_inds(2);
                val_dat = dat(val_s,:);


                if write_val == 1 || ALL_WRITE == 1
                %     writematrix(val1_dat,strcat('HPV',num2str(HPV_num),'_Val1.txt'));
                    writematrix(val_dat,strcat('Valsalva/',pt_id,'_Val',num2str(i),'.txt'))
                end
            end
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





