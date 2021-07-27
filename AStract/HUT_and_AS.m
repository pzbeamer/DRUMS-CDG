clear all;
T = readtable('PatientInfo07212021.csv','Headerlines',2);

HUT_rest=15;
AS_rest=20;
ind_HUT=1;
ind_AS=1;

for pt=3:872
    pt_id=T{pt,1};
    if ~isempty(T{pt,HUT_rest}{1})
        cell_of_HUT(ind_HUT)=pt_id;
        ind_HUT=ind_HUT+1;
    end
    if ~isempty(T{pt,AS_rest}{1})
        cell_of_AS{ind_AS}=pt_id;
        ind_AS=ind_AS+1;
    end
end

save('cell_of_HUT_and_AS.mat','cell_of_HUT','cell_of_AS')