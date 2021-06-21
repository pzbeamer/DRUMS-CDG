clear all
close all
%patient to read
pt_name = 'HPV22_20130903_Val1_WS.mat';

%parameters to optimize
INDMAP = [1 6 7 8 9 10 12 20 21];
%residual error vector
error = zeros(5,2);

for i = 0:4
    %call forward evaluation with 30-5*i second rest periods
    Func_DriverBasic_p(pt_name,[30 - 5*i 30]);
    
    nomHRfile =strcat('Valsalva/nomHR_residuals/',pt_name(1:end-7),'_',num2str(30-5*i),'_nomHR.mat');
    load(nomHRfile)
    %Call optimization with file generated by forward evaluation
    HR_LM = Func_DriverBasic_LM_p(nomHRfile,INDMAP);
    
    %calculate residual error
    start = find(Tdata == val_start);
    slut = find(Tdata == val_end);
    scaler = sqrt(length(Hdata(start:slut)))
    error(i+1,1) = norm((Hdata(start:slut)-HR_LM(start:slut))./Hdata(start:slut)/scaler);
    error(i+1,2) = (max(Hdata(start:slut)) - max(HR_LM(start:slut)))/max(Hdata(start:slut));
    figure(i+1)
    plot(Tdata,Hdata,Tdata,HR_LM)
    saveas(figure(i+1),strcat('Figures/',pt_name(1:5),'_',num2str(i+1),'.jpeg'))

    if error(i+1,1) < .8/scaler || error(i+1,2) < 5/max(Hdata(start:slut))
        break
    end
end
%identify which rest length did the best
%saveas(figure(i+1),strcat('Figures/',pt_name(1:end-7),'_bestRest.jpeg'))

