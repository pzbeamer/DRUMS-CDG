function [E_HR] = ECG_to_HR(Tdata,ECG,figureson)
%{
Makes continuous respiration signal. Loads in 
    Tdata - Time points in seconds (sec)
    ECG   - ECG data must be in millivolts (mV)
    figureson - If 1, it plots a bunch of figures 
%}
otherfigureson = 0; %Turn on and off all graphs except hr vs time
dt = mean(diff(Tdata)); 
Fs = round(1/dt); 

if otherfigureson == 1
    %Plot original ECG signal 
    figure(1)
    clf
    plot(Tdata,ECG,'k','linewidth',1)
    xlabel('Time (sec)')
    ylabel('ECG (mV)')
    set(gca,'FontSize',16)
end 

%% Correct baseline of ECG signal with medfilt1

%Filter out P waves and QRS complex with a window of 200 ms
smoothECG = medfilt1(ECG,round(.2/dt)); 

if otherfigureson == 1
    %Plot 200 ms filter on top of ECG
    figure(1); hold on;
    plot(Tdata,smoothECG,'r','linewidth',2)
end 
 
%Filter out T waves with a window of 600 ms 
smoothECG2 = medfilt1(smoothECG,round(.6/dt)); 

if otherfigureson == 1
    %Plot 600 ms filter on top of ECG
    figure(1); hold on;
    plot(Tdata,smoothECG2,'c','linewidth',2)
end

%Baseline corrected ECG signal
BaselineCorrectedECG = ECG - smoothECG2; 

if otherfigureson == 1
    %Plot baseline-correctd ECG 
    figure(2); clf;
    plot(Tdata,BaselineCorrectedECG,'k','linewidth',1)
end  

%% Savitsky-Golay Filter 

%Savitsky-Golay Filter filters out VERY low frequency signals. The window
%must be odd and within .15 sec 
SVGwindow = round(.15/dt); 
if mod(SVGwindow,2) == 0
    SVGwindow = SVGwindow + 1;
end 
%Check to ensure order is less than window size 
if SVGwindow > 5
    SVGorder = 5; 
else
    SVGorder = 3; 
end 
smoothECG3 = sgolayfilt(BaselineCorrectedECG,SVGorder,SVGwindow); 

if otherfigureson == 1
    %Plot SVG filter on top of baseline-corrected ECG 
    figure(2); hold on;
    plot(Tdata,smoothECG3,'r','linewidth',2)
end  

%% Accentuate peaks to easily find them 

%Can now extract Q and R peaks 
accentuatedpeaks = BaselineCorrectedECG - smoothECG3; 

if otherfigureson == 1
    %Plot of baseline-corrected ECG with accentuated peaks 
    figure(3)
    clf
    plot(Tdata,accentuatedpeaks,'k','linewidth',1)
    xlabel('Time (sec)')
    ylabel('Filtered ECG (mV)')
    set(gca,'FontSize',16)
end  

%Finds Q and R points with minimum peak distance of 200 ms 
[~,z] = findpeaks(accentuatedpeaks,'MinPeakDistance',round(.2/dt)); 
zz = mean(accentuatedpeaks(z)); 
[~,iR] = findpeaks(accentuatedpeaks,'MinPeakHeight',zz,'MinPeakDistance',round(.2/dt)); 


RRint = diff(Tdata(iR));%make this a step function with nodes at T_RRint  
T_RRint = Tdata(iR(1:end-1)); 


% RRstep = zeros(2*length(RRint),1);
% Tstep = zeros(2*length(RRint),1);
% 
% Tstep(1) = T_RRint(1);
% Tstep(end) = T_RRint(end);
% RRstep(1) = RRint(1);
% RRstep(end) = RRint(end);
% eps = 1e-2;
% for i =2:length(RRint+1)
%    Tstep(2*i-1) = T_RRint(i)-eps;
%    Tstep(2*i-2) = T_RRint(i);
%    
% end
% for i = 1:length(RRint)
%    RRstep(2*i-1) = RRint(i)+eps;
%    RRstep(2*i) = RRint(i);
% end

% plot(Tstep,RRstep)

HR = 60./RRint; 
%interpolate over step function and evaluate at Tdata 
E_HR_Func=griddedInterpolant(T_RRint,HR,'pchip');
E_HR = E_HR_Func(Tdata);

% [~,loc] = findpeaks(E_HR,'MinPeakDistance',round(50),'MinPeakProminence',20);
% 
% Tdata(loc) = [];
% E_HR(loc) = [];

if figureson == 1
    %plot(Tdata,E_HR,'b')
    scatter(Tdata,E_HR,2)
    title('Estimated HR')
    xlabel('Time')
    ylabel('Beats per minute')
end

end

