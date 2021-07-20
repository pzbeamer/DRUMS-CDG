clear all
close all

T = readtable('../Summary_Data_800_Gals/PatientInfo07132021.csv','Headerlines',2);
beta=cell(2,872);
ct=1;
for pt = 6:40
    pt
    pt_id = T{pt,1}{1}
    for i = 1
        pt_file_name = strcat(pt_id,'_val',num2str(i),'_nomHR.mat');
        
        if isfile(strcat('/Volumes/GoogleDrive/Shared drives/REU shared/ForwardEvaluation/nomHRs/',pt_file_name))
            load(strcat('/Volumes/GoogleDrive/Shared drives/REU shared/ForwardEvaluation/nomHRs/',pt_file_name),'data');
            load(strcat('/Volumes/GoogleDrive/Shared drives/REU shared/LSA/Vals_New/',pt_file_name(1:end-9),'WS.mat'),'val_dat');
            
            %for beta
            EKG=val_dat(:,2);
            Tall=val_dat(:,1);
            inds=makeR(Tall,EKG);
            Rpeaks=Tall(inds); %for not is is over the whole time even rest
            figure;
            plot(Rpeaks,EKG(inds),'o',Tall,EKG,'m');
            diffs=diff(Rpeaks);
            maxRint=max(diffs)*10^3;
            minRint=min(diffs)*10^3;
            maxSP=max(val_dat(:,4));
            baseSP=mean([data.Pdata(1:data.i_ts)' data.Pdata(data.i_t4:end)']);
            bet_a=(maxRint-minRint)/(maxSP-baseSP);
            %bet_a=bet_a*10^6;
            beta{1,ct}=bet_a;
            beta{2,ct}=pt_id;
            ct=ct+1;
        end
    end    
end