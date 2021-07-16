function [newdata] = TimeCut(data, restTime)

    timeAvailableS = data.val_start - data.Tdata(1);
    timeAvailableE = data.Tdata(end) - data.val_end;
    restTimeS = restTime(1);
    restTimeE = restTime(2);
    %Test if the rest time asked for exceeds available time
    if timeAvailableS < restTimeS
        restTimeS = timeAvailableS;
    end
    if timeAvailableE < restTimeE
        restTimeE = timeAvailableE;
    end
    
    
    %how much time are we cutting out
    timeCutS = timeAvailableS - restTimeS;
    timeCutE = timeAvailableE - restTimeE;
  
    
    %Cut all the data out
    startTime  = find(data.Tdata > data.Tdata(1) + timeCutS);
    endTime    = find(data.Tdata >= data.Tdata(end) - timeCutE);
    startTimeV = find(data.val_dat(:,1) > data.val_dat(1,1) + timeCutS);
    endTimeV   = find(data.val_dat(:,1) >= data.val_dat(end,1) - timeCutE);
    
    newdata.Tdata   = data.Tdata(startTime:endTime);
    newdata.Hdata   = data.Hdata(startTime:endTime);
    newdata.Pthdata = data.Pthdata(startTime:endTime);
    newdata.Rdata   = data.Rdata(startTime:endTime);
    newdata.Pdata  = data.Pdata(startTime:endTime);
    newdata.val_dat = data.val_dat(startTimeV:endTimeV,:);
    
    index1            = find(data.Tdata == newdata.Tdata(1));
    newdata.val_start = data.val_start - newdata.Tdata(1);
    newdata.val_end   = data.val_end - newdata.Tdata(1);
    i_ts              = data.i_ts - index1;
    newdata.i_ts      = i_ts;
    newdata.i_t1      = data.i_t1 - index1; 
    newdata.i_t2      = data.i_t2 - index1; 
    newdata.i_te      = data.i_te - index1; 
    newdata.i_t3      = data.i_t3 - index1; 
    newdata.i_t4      = data.i_t4 - index1;
    
    newdata.HminR  = min(newdata.Hdata(1:i_ts - 1)); 
    newdata.HmaxR  = max(newdata.Hdata(1:i_ts - 1)); 
    newdata.Hbar   = trapz(newdata.Hdata(1:i_ts - 1))/(i_ts - 1); 
    newdata.Rbar   = trapz(newdata.Rdata(1:i_ts - 1))/(i_ts - 1); 
    newdata.Pbar   = trapz(newdata.Pdata(1:i_ts - 1))/(i_ts - 1); 
    newdata.Pthbar = trapz(newdata.Pthdata(1:i_ts-1))/(i_ts-1); 
     
    
    newdata.age = data.age;
    newdata.dt  = data.dt;
    
    
    
  

end