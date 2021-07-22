Tall=readtable('Control Patient Info - Times.csv');

Val1rs=2;%val1 rest start
Val1s=3;%val1 start
Val1e=4;%val1 end
Val1re=5;%val1 rest end
Val2rs=6;%val1 rest start
Val2s=7;%val1 start
Val2e=8;%val1 end
Val2re=9;%val1 rest end
ValInds=[2:5;6:9];
N=18;
sex_ind=19;
Age_ind=20;
Height=21;
Weight=22;


for pt = [1:4 6:12]
    pt_id=Tall{pt,1};
    %load all data
    Twave=readtable(strcat('control',num2str(pt_id),'wave.Txt'));
    %Tbeats=readtable(strcat('control',num2str(pt_id),'beats.Txt'));
 
    
    %Assign known channels
    ECG_all=Twave{:,5};
    Tdata_all=Twave{:,1};
    %timeB=Tbeats{:,1};
    %SPdata=Tbeats{:,2};
    %Hdata=Tbeats{:,5};
    Pdata_all=Twave{:,2};
    
   

    %create time vector
    diff=Twave{end,1}-Twave{1,1};
    [~,m,s]=hms(diff);
    endtime=m*60+s;
    tvectW=linspace(0,endtime,length(Twave{:,1}));
    
    %change Tdata from a duration vector to by seconds
    [~,ms,ss]=hms(Twave{1,1});
    starttime=ms*60+ss;
    Tdata_all=tvectW';
    
    %make Hdata
    Hdata_all=ECG_to_HR(tvectW',ECG_all,0);
    
    %assign values
    notes=Tall{pt,N};
    Sex=Tall{pt,sex_ind};
    Age=Tall{pt,Age_ind};
    height=Tall{pt,Height};
    weight=Tall{pt,Weight};
    
    for i=1:2
        %find val start and end times
        %val_rest_start = celltime_to_seconds(Tall{pt,ValInds(i,1)});
        val_start = celltime_to_seconds(Tall{pt,ValInds(i,2)});
        val_end = celltime_to_seconds(Tall{pt,ValInds(i,3)});
        %val_rest_end = celltime_to_seconds(Tall{pt,ValInds(i,4)});

        %for the moment, just say rest before and after is 30 because based on 
        %protocal it is at least that long
        val_rest_start = val_start-30;
        val_rest_end = val_end+30;

        %find indices for val start, end, and rest times in time vector
        ind_vals=find(abs(tvectW-val_start)==min(abs(tvectW-val_start))); %index for when val starts
        ind_vale=find(abs(tvectW-val_end)==min(abs(tvectW-val_end))); %index for when val ends
        ind_vals_r=find(abs(tvectW-val_rest_start)==min(abs(tvectW-val_rest_start))); %index for when val rest starts
        ind_vale_r=find(abs(tvectW-val_rest_end)==min(abs(tvectW-val_rest_end))); %index for when val rest ends

        %Resize everything to just capture unsampled val data
        ECG=ECG_all(ind_vals_r:ind_vale_r);
        Tdata=Tdata_all(ind_vals_r:ind_vale_r);
        Pdata=Pdata_all(ind_vals_r:ind_vale_r);
        tvectWval=tvectW(ind_vals_r:ind_vale_r);
        Hdata=Hdata_all(ind_vals_r:ind_vale_r);
        Rdata=makeresp(tvectWval',ECG,0);
        minPeakDistance = .3;
        [SPdata_not_sampled S] = SBPcalc_ben(tvectWval',Pdata,minPeakDistance,0);
        val_dat=[Tdata ECG Hdata Pdata];
        
        %get sampled val data
        s=1:20:length(Hdata); %sampling vector for 10 Hz
        ECG=ECG(s);
        Tdata=Tdata(s);
        Pdata=Pdata(s);
        Hdata=Hdata(s);
        Rdata=Rdata(s);
        SPdata = SPdata_not_sampled(s);
        
        %we know that no flags are tripped
        flag=[0;0;0];
        
        save(strcat('control',num2str(pt_id),'_val',num2str(i),'_WS.mat'),... %Name of file
                    'Age','height','weight','ECG','Hdata','Pdata','Rdata','Sex','SPdata','Tdata','flag',...
                    'val_rest_start','val_start','val_end','val_rest_end','notes','val_dat','tvectWval')

        %figure;
        %plot(timeWval,Pdataval)
        %figure;
        %plot(timeWval,Rdata)
        %figure;
        %plot(timeWval,Hdata)
        
    end
    

    %tvectshort=linspace(0,endtime,length(Tbeats{:,1}));
    %valsshort=find(abs(tvectshort-v1s)==min(abs(tvectshort-v1s)));
    %valeshort=find(abs(tvectshort-v1e)==min(abs(tvectshort-v1e)));



    %figure(1);
    %plot(timeW(vals:vale),FPresh(vals:vale))
    %plot(timeW(vals:vale),FPresh(vals:vale))
    %figure(2);
    %plot(timeB(valsshort:valeshort),Hdata(valsshort:valeshort))
    %plot(tvectshort(valsshort:valeshort),Hdata(valsshort:valeshort))
    %figure(3);
    %hold on;
    %plot(timeW,FPresh)
    %plot(timeB,SPdata)
    %figure(4);
    %plot(timeW,Pdata)
    %figure(5);
    %plot(timeB,Hdata)
end

%% Cell time to seconds
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