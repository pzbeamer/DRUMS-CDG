clear all
close all

T = readtable('../Summary_Data_800_Gals/PatientInfo07132021.csv','Headerlines',2);



%pt 289 ('HPV224_20151203') time reset
%pt 330 ('HPV266_20151210') still bad

%No fucking clue:
%pt 78
%pt 172
%pt 124 bad ('HPV73_20141210') 
%pt 654 ('HPV592_20150825')
%pt 655 ('HPV592_20151211')
%pt 656 ('HPV593_20160419')
%pt 765 ('HPV701_20160816')
%pt 818 ('HPV753_20160610')
%pt 848 ('HPV782_20161221_A')
%pt 858 ('HPV788_20161124')


%pt 815 'HPV750_20160525' data trash, nothing to be done


%pt 249 ('HPV186_20151008') No val_dat?

%Remake pt 748 workspace

for pt = 859:872
    pt
    pt_id = T{pt,1}{1}
    for i = 1:1
        pt_file_name = strcat(pt_id,'_val',num2str(i),'_WS.mat');
        
        if isfile(strcat('/Volumes/GoogleDrive/Shared drives/REU shared/LSA/Vals_New/',pt_file_name))
            Func_DriverBasic_q(pt_file_name,[30 30]);
        end
    end    
end