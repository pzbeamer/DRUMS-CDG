function [pars0]=load_global_reverse(data,orig_pars, INDMAP)

global pars0

age    = data.age;  

%Initial mean values
Pbar   = data.Pbar;
HminR  = data.HminR; 
HmaxR  = data.HmaxR; 
Hbar   = data.Hbar; 
%% PARAMETERS  

A    = 5;          
B    = 0.5;           

Kb   = 0.1;          
Kpb  = 5;
Kpr  = 1; 
Ks   = 5; 
          
taupb = 1.8;          
taupr = 6;
taus  = 10;          
tauH  = 0.5;

qw   = .04;        
qpb  = 10*(1 - Kb);          
qpr  = 1; 
qs   = 10*(1 - Kb);          

Ds   = 3;



%% Patient specific parameters

sw  = data.Pbar;           
spr = data.Pthbar;  

%Intrinsic HR
HI = 118 - .57*age;  
if HI < Hbar 
    HI = Hbar;
end 
%Maximal HR
HM = 208 - .7*age;    
Hs = (1/Ks)*(HM/HI - 1); 

%% Calculate sigmoid shifts

Pc_ss  = data.Pbar; 
ewc_ss = 1 - sqrt((1 + exp(-qw*(Pc_ss - sw)))/(A + exp(-qw*(Pc_ss - sw)))); 

Pa_ss  = data.Pbar - data.Pthbar; 
ewa_ss = 1 - sqrt((1 + exp(-qw*(Pa_ss - sw)))/(A + exp(-qw*(Pa_ss - sw)))); 

n_ss   = B*ewc_ss + (1 - B)*ewa_ss;

Tpb_ss = .8;
Ts_ss  = .2; 

%Steady-state sigmoid shifts 
spb = n_ss + log(Kpb/Tpb_ss - 1)/qpb;  
ss  = n_ss -  log(Ks/Ts_ss - 1)/qs;   

%% At end of expiration and inspiration

Gpr_ss = 1/(1 + exp(qpr*(data.Pthbar - spr)));

Tpr_ss = Kpr*Gpr_ss; 
Hpr = (HmaxR - HminR)/HI/Tpr_ss ;

Hpb = (1 - Hbar/HI + Hpr*Tpr_ss + Hs*Ts_ss)/Tpb_ss;

%% Outputs

pars0 = [A; B;                       %1-2
    Kpb; Kpr; Ks;                   %Gains 3-5
    taupb; taupr; taus; tauH;       %Time Constants 6-9
    qw; qpb; qpr; qs;               %Sigmoid Steepnesses 10-13
    sw; spb; spr; ss;               %Sigmoid Shifts 14-17
    HI; Hpb; Hpr; Hs;               %Heart Rate Parameters 18-21
    Ds];                            %Delay 22

pars0(INDMAP) = orig_pars;

%pars0(21) = (1/Ks)*(HM/pars0(18) - 1);
%pars0(20) = (HmaxR - HminR)/HI/Tpr_ss ;
%pars0(15) = n_ss + log(Kpb/Tpb_ss - 1)/qpb;  
%pars0(17)  = n_ss -  log(pars0(5)/Ts_ss - 1)/pars0(13); 
pars0(19) = (1 - Hbar/HI + pars0(20)*Tpr_ss + Hs*Ts_ss)/Tpb_ss;


end 

