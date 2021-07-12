
close all
%% Parameters is seperate windows
num_rand_starts = 10;

for i =1:num_rand_starts
    load(strcat('Valsalva/optHR_residuals/HPV20_20120919_val1_30_',num2str(i),'_optHR.mat')) %Load in whatever data you want
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
for i = 1:npars
    figure(i)
    yticks([0,0.5,1])
    yticklabels({'Lower bound','0.5','Upper Bound'})
    xlabel('Iteration number')
    ylim([0,1])
    xlim([0,1])
    title(strcat('Ind = ',num2str(INDMAP(i))))
    set(gca,'fontsize',16)
end
