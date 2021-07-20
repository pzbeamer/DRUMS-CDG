clear all

<<<<<<< HEAD
T = readtable('../PatientInfo07132021.csv','Headerlines',2);
=======
T = readtable('../PatientInfo07192021.csv','Headerlines',2);
>>>>>>> a1fba088ef8350aad17af251458b51c7bc539c55

markers = zeros(869,11); %alpha, beta, gamma, HRbeforeVal, HRafterVal, SBPbeforeVal, SBPafterVal, maxHR2, maxBP2, maxHR3, maxBP3
barkers = zeros(869,2);

for pt = [3:17 19:818 820:872]
    pt
    pt_id = T{pt,1}{1}
        pt_file_name = strcat(pt_id,'_val1_nomHR.mat');
        
        if isfile(strcat('/Volumes/GoogleDrive/Shared drives/REU shared/ForwardEvaluation/nomHRs/',pt_file_name))
              load(strcat('/Volumes/GoogleDrive/Shared drives/REU shared/ForwardEvaluation/nomHRs/',pt_file_name),'data');
              load(strcat('/Volumes/GoogleDrive/Shared drives/REU shared/LSA/Vals_New/',pt_file_name(1:end-9),'WS.mat'),'val_dat');
            
%% Alpha

              pressure = data.Pdata(data.i_t1:data.i_te);
              time = data.Tdata(data.i_t1:data.i_te);

              maximum = find(pressure == max(pressure));
              minimum = find(pressure == min(pressure));
              pt-3;
              markers(pt-3,1) = (pressure(maximum) - pressure(minimum))/(time(maximum)-time(minimum));%alpha
%% Beta
                EKG=val_dat(:,2);
                Tall=val_dat(:,1);
                inds=makeR(Tall,EKG); % calls makeR.m
                Rpeaks=Tall(inds); % for not is is over the whole time even rest
                %figure;
                %plot(Rpeaks,EKG(inds),'o',Tall,EKG,'m');
                diffs=diff(Rpeaks);
                maxRint=max(diffs)*10^3;
                minRint=min(diffs)*10^3;
                maxSP=max(val_dat(:,4));
                baseSP=mean([data.Pdata(1:data.i_ts)' data.Pdata(data.i_t4:end)']);
                markers(pt-3,2)=(maxRint-minRint)/(maxSP-baseSP); %beta
                barkers(pt-3,1) = markers(pt-3,2);
                %bet_a=bet_a*10^6;

    %             beta{1,ct}=bet_a;
    %             beta{2,ct}=pt_id;
    %             ct=ct+1;
    %% Gamma 
                pt_id
                markers(pt-3,3) = max(data.Hdata(data.i_te:data.i_t3))/min(data.Hdata(data.i_t3:data.i_t4)); %gamma
                barkers(pt-3,2) = markers(pt-3,3);

    %% Baselines

    val_start = data.val_start;
                val_end = data.val_end;
                Hdata = data.Hdata;
                Pdata = data.Pdata;

                markers(pt-3,4) = mean(Hdata(1:round(val_start))); %HRbeforeVal
                markers(pt-3,5) = mean(Hdata(round(val_end):end)); %HRafterVal
                markers(pt-3,6) = mean(Pdata(1:round(val_start))); %SBPbeforeVal
                markers(pt-3,7) = mean(Pdata(round(val_end):end)); %SBPafterVal

        %% Max HR and BP

        %Phase 2
                markers(pt-3,8) = max(Hdata(data.i_t1:data.i_te)); %maxHR2
                markers(pt-3,9) = max(Pdata(data.i_t1:data.i_te)); %maxBP2

        %Phase 3
                markers(pt-3,10) = max(Hdata(data.i_te:data.i_t3)); %maxHR3
                markers(pt-3,11) = max(Pdata(data.i_te:data.i_t3)); %maxBP3
    end 
end
%% Save    
save('markers.mat','markers','barkers')