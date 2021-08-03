%This script is meant to plot valsalva 1, HUT, and AS if they exist for
%patients
%Needs file 

T = readtable('PatientInfo07212021.csv');
FS = 16;
% load('../Summary_Data_800_Gals/summary.mat')%,'uniqueTimes');

for pt = 8:20 %Start indexing at 8
    if ~min(T{pt,1}{1}(4:6)==T{pt-1,1}{1}(4:6)) %Don't show the same patient twice
        if isfile(strcat('/Volumes/GoogleDrive/Shared drives/REU shared/LSA/AS/',T{pt,1}{1},'_AS_WS.mat'))
            load(strcat('/Volumes/GoogleDrive/Shared drives/REU shared/LSA/AS/',T{pt,1}{1},'_AS_WS.mat'));
            start_ind_a=find(abs(Tdata-AS_start)==min(abs(Tdata-AS_start)));
                end_avg_ind_a=find(abs(Tdata-(AS_start-5))==min(abs(Tdata-(AS_start-5))));


                begin_avg_ind_a=find(abs(Tdata-(AS_start-AS_rest))==min(abs(Tdata-(AS_start-AS_rest))));

                avg_HR_before_a=median(Hdata(begin_avg_ind_a:end_avg_ind_a));
                maxHR_a=max(movmean(Hdata(start_ind_a:end), 50));
                figure(pt)
                clf
                subplot(2,2,1)
                hold on
                plot(Tdata,Hdata,'linewidth',3)
                xlim([min(Tdata),max(Tdata)])
                if num2str(T{pt,3}{1})>19
                    yline(avg_HR_before_a+30,'r','linewidth',3)
                else
                    yline(avg_HR_before_a+40,'r','linewidth',3)

                end
                xline(AS_start,'b','linewidth',3)
                title(strcat('AS, pt = ',T{pt,1}),'interpreter','none')
                ylabel('HR (bpm)')
                set(gca,'fontsize',FS)

                subplot(2,2,3)
                plot(Tdata,Pdata)
                title(strcat('Pt index = ',num2str(pt)))
                xlim([min(Tdata),max(Tdata)])
                hold on
                xline(AS_start,'b','linewidth',3)
                ylabel('BP (mmHg)')
                xlabel('Time (s)')
                set(gca,'fontsize',FS)

        end

        %HUT
        if isfile(strcat('/Volumes/GoogleDrive/Shared drives/REU shared/LSA/HUT/',T{pt,1}{1},'_HUT_WS.mat'))
            load(strcat('/Volumes/GoogleDrive/Shared drives/REU shared/LSA/HUT/',T{pt,1}{1},'_HUT_WS.mat'));
            start_ind_a=find(abs(Tdata-AS_start)==min(abs(Tdata-AS_start)));
                end_avg_ind_a=find(abs(Tdata-(AS_start-5))==min(abs(Tdata-(AS_start-5))));


                begin_avg_ind_a=find(abs(Tdata-(AS_start-AS_rest))==min(abs(Tdata-(AS_start-AS_rest))));

                avg_HR_before_a=median(Hdata(begin_avg_ind_a:end_avg_ind_a));
                maxHR_a=max(movmean(Hdata(start_ind_a:end), 50));
                subplot(2,2,2)
                hold on
                plot(Tdata,Hdata,'linewidth',3)
                xlim([min(Tdata),max(Tdata)])
                if num2str(T{pt,3}{1})>19
                    yline(avg_HR_before_a+30,'r','linewidth',3)
                else
                    yline(avg_HR_before_a+40,'r','linewidth',3)

                end
                xline(HUT_start,'b','linewidth',3)
                title(strcat('HUT, pt = ',T{pt,1}),'interpreter','none')
                ylabel('HR (bpm)')
                set(gca,'fontsize',FS)

                subplot(2,2,4)
                plot(Tdata,Pdata)
                xlim([min(Tdata),max(Tdata)])
                title(strcat('Pt index = ',num2str(pt)))
                hold on
                xline(HUT_start,'b','linewidth',3)
                ylabel('BP (mmHg)')
                xlabel('Time (s)')
                set(gca,'fontsize',FS)

        end
    end
end