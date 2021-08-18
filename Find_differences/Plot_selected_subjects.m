pcell = {'HPV7_20131029';'HPV36_20140224';...
    'HPV53_20140623';'HPV55_20140804';'HPV62_20140822';...
    'HPV65_20141003';'HPV66_20141009';'HPV68_20150112';
    'HPV94_20150608';'HPV102_20150323'};

ccell = {'HPV77_20141219';...
    'HPV81_20150323';'HPV82_20150309';'HPV83_20150410';
    'HPV91_20150427';'HPV50_20140930';'HPV47_20140523';
    'HPV34_20140217';'HPV35_20140221'};
figureson = 1;
for i = 1:length(ccell)
%     path = '/Volumes/GoogleDrive/.shortcut-targets-by-id/1Vnypyb_cIdCMJ49vzcg8V7cWblpVCeYZ/HPV_Data/MATLAB_Files/';
    pt_id = ccell{i};
    load(strcat('../Optimized/',pt_id,'_optimized.mat'))
    INDMAP = saveDat.INDMAP;
    WS = strcat('../Cluster/MatFiles/',pt_id,'_val1_WS.mat');
    data = load_data(WS);
    data = TimeCut(data,[saveDat.restTime,30]);
    
    [Sigs,HR,time] = DriverBasicME(data,INDMAP,saveDat.optpars,1,i,figureson);
    
    if figureson
        figure(i)
        subplot(2,2,1)

        title(pt_id(1:5))
        if any(saveDat.flag)
            figure(i)
            subplot(2,2,2)
            title('There is a saveDat flag')
        end
    end
    
   
    
end