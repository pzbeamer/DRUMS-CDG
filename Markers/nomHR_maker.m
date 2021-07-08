clear all
close all

T = readtable('PatientInfo_063021.csv','Headerlines',2);


%pt 216 fixed in spreadsheet
%pt 226 ('HPV164_20150727') fixed in spreadsheet
%pt 235 ('HPV172_20150804') fixed in spreadsheet
%pt 249 ('HPV186_20151008') No val_dat?
%pt 279 ('HPV216_20150930')
%pt 281 (HPV218_20151008)
%pt 289 ('HPV224_20151203')
%pt 309 ('HPV242_20151111')
%pt 330 ('HPV266_20151210')
%pt 344 ('HPV279_20160107')
%pt 367 ('HPV298_20160105')
%Caroline fixed through here

%pt 377 ('HPV309_20160112')
%pt 446 ('HPV376_20160210')
%pt 461 ('HPV391_20160223')
%pt 471 ('HPV401_20160225')
%pt 474 ('HPV404_20160201')
%pt 477 ('HPV407_20160307')
%pt 538 ('HPV471_20160413')
%pt 565 ('HPV498_20160414')

%pt 567 ('HPV500_20160510') fixed ss
%pt 580 ('HPV512_20160427') fixed ss

%No fucking clue:
%pt 124 bad ('HPV73_20141210') 
%pt 654 ('HPV592_20150825')
%pt 655 ('HPV592_20151211')
%pt 656 ('HPV593_20160419')


for pt = 580%657:684
    pt
    pt_id = T{pt,1}{1}
    for i = 1:4
        pt_file_name = strcat(pt_id,'_val',num2str(i),'_WS.mat');
        
        if isfile(strcat('/Volumes/GoogleDrive/Shared drives/REU shared/LSA/Vals_New/',pt_file_name))
            Func_DriverBasic_q(pt_file_name,[30 30]);
        end
    end    
end