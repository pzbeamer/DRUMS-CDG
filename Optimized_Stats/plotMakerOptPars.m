clear all
close all
load('4plots.mat')

%% Cluster plots
    
% % %stuff = dbscan(opt_pars,9,20);
% % figure(1);
% % silhouette(opt_pars,stuff);


%% Boxplots

for i = 1:5
    
    plot_pars(:,i) = opt_pars(:,i)/median(opt_pars(:,i));
%     x(i) = x(i)/median(opt_pars(:,i));
%     y(i) = y(i)/median(opt_pars(:,i));
    
end
% figure(1)
% hold on
% h = boxplot(plot_pars,'Whisker',20,'Color','k','Widths',.35,'Positions',[.5 1 1.5 2 2.5]);
% plot([.5 1 1.5 2 2.5],x,'p','Color','b','MarkerSize',25,'MarkerFaceColor','b')
% plot([.5 1 1.5 2 2.5],y,'p','Color','r','MarkerSize',25,'MarkerFaceColor','r')
% set(gca,'XTickLabel',{' '})
% set(h,{'linew'},{3})
% yticks([0 4 8 12 16])
% set(gca,'fontsize',32)
% ylabel('Relative Parameters')
% saveas(figure(1),'boxplot.eps')

%% Scatter

hiPOTs = [];
midPOTs = [];
noPOTs = [];
figure (2)
hold on


for i = 1: length(POTS)
    if POTS(i) == 2
        hiPOTs = [hiPOTs ; plot_pars(i,1:5)];
    
    elseif POTS(i) == 1
        midPOTs = [midPOTs ; plot_pars(i,1:5)];
    else
        noPOTs = [noPOTs ; plot_pars(i,1:5)];
    end
end

for i = 1:5
    
    plot(i*.5*ones(length(hiPOTs(:,i)),1)+.1*ones(length(hiPOTs(:,i)),1),hiPOTs(:,i),'o','Color','b')
    plot(i*.5*ones(length(midPOTs(:,i)),1)+.1*ones(length(midPOTs(:,i)),1),midPOTs(:,i),'o','Color','b')
    plot(i*.5*ones(length(noPOTs(:,i)),1),noPOTs(:,i),'o','Color','r')

end
xlim([0,3])
print('scatterboiss','-dpng')
print('scatterboiss','-depsc2')

%% SVD plotting


[U, S, V] = svd(opt_pars);
Se = S(1:2,1:2);
Ue = U(:,1:2);
PCA = Ue * Se;
% cluster1 = [];
% cluster2 = [];
% 
% for i = 1: length(stuff)
%     if stuff(i) == 1
%         cluster1 = [cluster1; PCA(i,1:3)];
%     
%     else
%         
%         cluster2 = [cluster2; PCA(i,1:2)];
%     end
%     
% end
% 
% figure(10)
% clf
% hold on
% %  plot(cluster1(:,1),cluster1(:,2),'o', 'Color','b')
% %  plot(cluster2(:,1),cluster2(:,2),'o','Color','r')
% scatter3(cluster1(:,1),cluster1(:,2),cluster1(:,3),'','b')
% scatter3(cluster2(:,1),cluster2(:,2),cluster2(:,3),'','r')


% hiPOTs = [];
% midPOTs = [];
% noPOTs = [];
% for i = 1: length(POTS)
%     if POTS(i) == 2
%         hiPOTs = [hiPOTs ; PCA(i,1:3)];
%     
%     elseif POTS(i) == 1
%         midPOTs = [midPOTs ; PCA(i,1:3)];
%     else
%         noPOTs = [noPOTs ; PCA(i,1:3)];
%     end
% end
% hold on
% % plot(hiPOTs(:,2),hiPOTs(:,3),'o', 'Color','b')
% % plot(midPOTs(:,2),midPOTs(:,3),'o','Color','r')
% % plot(noPOTs(:,2),noPOTs(:,3),'o','Color','g')
% scatter3(hiPOTs(:,1),hiPOTs(:,2),hiPOTs(:,3),'', 'b')
% scatter3(midPOTs(:,1),midPOTs(:,2),midPOTs(:,3),'','r')
% scatter3(noPOTs(:,1),noPOTs(:,2),noPOTs(:,3),'','g')