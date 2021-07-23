
load('4plots.mat')

%% Cluster plots
    
% stuff = dbscan(opt_pars,9,20);
% figure();
% silhouette(opt_pars,stuff);
% print('silohette','-dpng')
% print('silohette','-depsc2')
% figure();
% plot(opt_pars(:,1),opt_pars(:,2),'o')


%% Boxplots

% % for i = 1:5
% %     
% %     plot_pars(:,i) = opt_pars(:,i)/median(opt_pars(:,i));
% % %     x(i) = x(i)/median(opt_pars(:,i));
% % %     y(i) = y(i)/median(opt_pars(:,i));
% %     
% % end
% % figure(1)
% % hold on
% % h = boxplot(plot_pars,'Whisker',20,'Color','k','Widths',.35,'Positions',[.5 1 1.5 2 2.5]);
% % plot([.5 1 1.5 2 2.5],x,'p','Color','b','MarkerSize',25,'MarkerFaceColor','b')
% % plot([.5 1 1.5 2 2.5],y,'p','Color','r','MarkerSize',25,'MarkerFaceColor','r')
% % set(gca,'XTickLabel',{' '})
% % set(h,{'linew'},{3})
% % yticks([0 4 8 12 16])
% % set(gca,'fontsize',32)
% % ylabel('Relative Parameters')
% % saveas(figure(1),'boxplot.eps')
% 
% %% Scatter
% 
% plot = [];
% hiPOTs = [];
% midPOTs = [];
% noPOTs = [];
% figure (2)
% hold on
% 
% 
% for i = 1: length(POTS)
%     if POTS(i) == 2
%         hiPOTs = [hiPOTs ; opt_pars(i,1:5)];
%     
%     elseif POTS(i) == 1
%         midPOTs = [midPOTs ; opt_pars(i,1:5)];
%     else
%         noPOTs = [noPOTs ; opt_pars(i,1:5)];
%     end
% end
% 
% for i = 1:5
%     
%     plot(hiPots(:,i),i*.5*ones(length(hiPots(:,i),1)))
%     plot(midPots(:,i),i*.5*ones(length(midPots(:,i),1)))
%     plot(noPots(:,i),i*.5*ones(length(noPots(:,i),1)))
% 
%     
% end


%% SVD plotting


[U, S, V] = svd(opt_pars);
Se = S(1:2,1:2);
Ue = U(:,1:2);
PCA = Ue * Se;
cluster1 = [];
cluster2 = [];

for i = 1: length(stuff)
    if stuff(i) == 1
        cluster1 = [cluster1; PCA(i,1:2)];
    
    else
        
        cluster2 = [cluster2; PCA(i,1:2)];
    end
    
end

figure(10)
clf
hold on
%  plot(cluster1(:,1),cluster1(:,2),'o', 'Color','b')
%  plot(cluster2(:,2),cluster2(:,2),'o','Color','r')
% scatter3(cluster1(:,1),cluster1(:,2),cluster1(:,3),'','b')
% scatter3(cluster2(:,1),cluster2(:,2),cluster2(:,3),'','r')

plot = [];
hiPOTs = [];
midPOTs = [];
noPOTs = [];
for i = 1: length(POTS)
    if POTS(i) == 2
        hiPOTs = [hiPOTs ; PCA(i,1:2)];
    
    elseif POTS(i) == 1
        midPOTs = [midPOTs ; PCA(i,1:2)];
    else
        noPOTs = [noPOTs ; PCA(i,1:2)];
    end
end
hold on
% plot(hiPOTs(:,1),hiPOTs(:,2),'o', 'Color','b')
% plot(midPOTs(:,1),midPOTs(:,2),'o','Color','r')
% plot(noPOTs(:,1),noPOTs(:,2),'o','Color','g')
scatter(hiPOTs(:,1),hiPOTs(:,2),'o','b')
scatter(midPOTs(:,1),midPOTs(:,2),'o','r')
scatter(noPOTs(:,1),noPOTs(:,2),'o','g')
print('PCAscatter','-dpng')
print('PCAscatter','-depsc2')