%index 30: fits are not too different, only one wayward optimization,
%median fine

function check_Driver
close all
    index=23;
    format shortg;

    load('../../../Optimized/flagDiverge.mat')
    pt_id=flagDiverge{index};
    load(strcat('../../../Optimized/',pt_id,'_optimized.mat'))
    
    %Parameters to estimate (taupb, taus, spb, spr, Hpr)
    INDMAP = saveDat.INDMAP;
    %Construct file to read
    pt_WS = strcat(pt_id,'_val1_WS.mat');
    %Load needed patient data
    data = load_data(pt_WS);
    data = TimeCut(data,[saveDat.restTime,30]);
    %Run 7 additional optimizations with random nominal parameter values
    for k = 1:2%1:8
        DriverBasicME(data,INDMAP,saveDat.optpars,k);
    end
    pt_WS
end



