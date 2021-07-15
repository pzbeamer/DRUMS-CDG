%% Select path
%user = 
% 1 - Ben
% 2 - Justen
% 3 - Mette
user = 2; 

if user == 1
    %Ben, set your path
elseif user == 2
    gpath = '/Volumes/GoogleDrive/.shortcut-targets-by-id/1Vnypyb_cIdCMJ49vzcg8V7cWblpVCeYZ/HPV_Data';
elseif user == 3 
    %Mette
end

%Manever to Valsalva folder
g_folder_path = strcat(gpath,'/Prepped_workspaces/Valsalva/');
load(strcat(gpath,'/txt_Files/Valsalva/File_name_cell_02142021.mat')); %Loads "cell_of_file_names"
%%
for i = 7%:11%11
    Func_DriverBasic_LM(cell_of_file_names{i,1}(1:end-4),g_folder_path);
%     Func_DriverBasic_LM(pt_file_name,g_folder_path)
end

%% Run random starts
for i = 5%:11%11
    for saveindex = 8%2:8
        Func_DriverRandStarts_LM(cell_of_file_names{i,1}(1:end-4),g_folder_path,saveindex);
    end
%     Func_DriverBasic_LM(pt_file_name,g_folder_path)
end
