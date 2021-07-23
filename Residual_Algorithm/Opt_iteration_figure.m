
close all
%% Parameters is seperate windows
num_rand_starts = 10;
srate = 24;

for i =1:num_rand_starts
    %load(strcat('Valsalva/optHR_residuals/HPV20_20120919_val1_30_',num2str(i),'_optHR.mat')) %Load in whatever data you want
    load(strcat('Valsalva/optHR_residuals/HPV22_20130903_val1_30_',num2str(i),'_optHR.mat'))
    %load(strcat('Valsalva/optHR_residuals/HPV27_20140124_val1_30_',num2str(i),'_optHR.mat'))
    %load(strcat('Valsalva/optHR_residuals/HPV28_20140124_val1_15_',num2str(i),'_optHR.mat'))
    %load(strcat('Valsalva/optHR_residuals/HPV32_20140217_val1_30_',num2str(i),'_optHR.mat'))
    %load(strcat('Valsalva/optHR_residuals/HPV33_20140217_val1_30_',num2str(i),'_optHR.mat'))
    %load(strcat('Valsalva/optHR_residuals/HPV34_20140217_val1_30_',num2str(i),'_optHR.mat'))
    %load(strcat('Valsalva/optHR_residuals/HPV41_20140509_val1_30_',num2str(i),'_optHR.mat'))
    %load(strcat('Valsalva/optHR_residuals/HPV45_20121029_val1_30_',num2str(i),'_optHR.mat'))
    %load(strcat('Valsalva/optHR_residuals/HPV55_20140804_val1_30_',num2str(i),'_optHR.mat'))
    
   

    



    npars = length(xhist{1}); %How many parameters are you optimizing?
    
    xs = zeros(npars,length(xhist)); %Preallocate xs vector
    for i = 1:length(xhist) %Put entries of xhist cell into a matrix (xs)
        xs(:,i) = xhist{i};
    end

    
    
    for i = 1:npars %Plot each line of iteration history
        figure(i)
        hold on
        plot(linspace(0,1,length(xs)),xs(i,:),'linewidth',4)
    end
    
end

labs = cell(npars,1); %Make labels for plot
for i = 1:npars
    labs{i} = num2str(INDMAP(i));
end
for i = 1:3
    eight=figure(i);
    yticks([0,0.5,1])
    yticklabels({'Lower bound','0.5','Upper Bound'})
    xlabel('Iteration number')
    ylim([0,1])
    xlim([0,1])
    title(strcat('Ind = ',num2str(INDMAP(i))))
    set(gca,'fontsize',30)
    print('eight','-depsc2');
    %saveas(figure(i),strcat(num2str(i),'.eps'))
end
