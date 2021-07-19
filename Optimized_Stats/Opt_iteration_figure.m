
close all
%% Parameters is seperate windows
index=5;
num_rand_starts = 8;
load('flagDiverge.mat')
load(strcat(flagDiverge{index},'_optimized.mat'))
flagDiverge{index}
for i =1:num_rand_starts
    load(strcat(flagDiverge{index},'_optimized.mat'))
    
    xhist=saveDat.xhist;
    xhist=xhist(i,:);
    INDMAP=saveDat.INDMAP;
    



    npars = length(xhist{1}); %How many parameters are you optimizing?
    check=0;
    
    xs = zeros(npars,length(xhist)); %Preallocate xs vector
    for i = 1:length(xhist) %Put entries of xhist cell into a matrix (xs)
        if ~isempty(xhist{i})
            xs(:,i) = xhist{i};
            check=check+1;
        end
    end
    %npars=5;
    xs=xs(:,1:check);
    
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
    saveas(figure(i),strcat(num2str(i),'.jpeg'))
end
