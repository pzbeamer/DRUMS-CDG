

function [SPdata] = SBPcalc_HRpks_ben(Tdata,Pdata,graphsYoN)



figson = graphsYoN; 


dt = mean(diff(Tdata)); 

%Pdata = Pdata/max(Pdata); 

%% Filter out oscillations due to respiration at .1 Hz 

Pmean = movmean(Pdata,round(1/.1)); 

if figson == 1
    figure(10)
    clf
    hold on 
    plot(Tdata,Pdata,'b')
    plot(Tdata,Pmean,'r','linewidth',2)
end 

%% Remove baseline wander 

BaselinecorrectedP = Pdata - Pmean; 

if figson == 1
    figure(11)
    
    hold on 
    plot(Tdata,BaselinecorrectedP,'b')
end 

%% Find peaks 

% Find all peaks that are a minimum of .15 s apart. We use 0.15 s to so 
% that we don't pick up dicrotic notches as SBP peaks 
[~,z] = findpeaks(BaselinecorrectedP,'MinPeakDistance',round(.15/dt)); 

% Find the mean height of all the peaks 
zz = mean(BaselinecorrectedP(z)); 

% Find the peaks again that greater than 1/2 of the mean of the height of
% all the peaks 
[~,iSP] = findpeaks(BaselinecorrectedP,'MinPeakHeight',zz/2,'MinPeakDistance',round(.15/dt)); 

% Assign vectors for the SBP interpolant. We need to have the first and
% last time points to ensure the interpolant doesn't do crazy stuff at the
% endpoints. To do this, I just repeat the first and last peak point 
t_SP = [Tdata(1); Tdata(iSP); Tdata(end)]; 
x_SP = [Pdata(iSP(1)); Pdata(iSP); Pdata(iSP(end))]; 
S = griddedInterpolant(t_SP,x_SP,'pchip'); 

% This is the new systolic blood pressure curve 
SPdata1 = S(Tdata); 

if figson == 1

    figure(11)
    hold on 
    plot(Tdata(iSP),BaselinecorrectedP(iSP),'ro')

    figure(12)
    clf
    hold on 
    plot(Tdata,Pdata,'b',Tdata(iSP),Pdata(iSP),'ro')
    plot(Tdata,SPdata1,'r')
end

%% Reassign SPdata 

SPdata = SPdata1; 
end
 



