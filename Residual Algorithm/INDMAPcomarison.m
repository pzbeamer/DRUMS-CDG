clear all
close all
%parameters to optimize
INDMAP = [1 6 7 8 9 10 12 20 21];

load File_name_cell_06072021_short.mat   
q = [1 2 3 5 6 8 9 10 14 17 24 29 30];

for i=1:length(q)
    u{i} = strcat(cell_of_file_names{q(i),1}(1:end-9))
end


for j = 1:length(u)
    u{j};
    pt_name = strcat(u{j},'_Val1_WS.mat'); 
    Func_DriverBasic_p(pt_name,[30 30]);
    nomHRfile =strcat('Valsalva/nomHR_residuals/',pt_name(1:end-7),'_30_nomHR.mat');
    load(nomHRfile)
    HR_LM = Func_DriverBasic_LM_p(nomHRfile,INDMAP);
end
