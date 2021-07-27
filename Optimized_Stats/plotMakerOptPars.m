clear all
close all
load('4plots.mat')

%% Cluster plots
    
% % %clustering = dbscan(opt_pars,9,20);
% % figure(1);
% % silhouette(opt_pars,clustering);


%% Boxplots

% for i = 1:5
%     
%     plot_pars(:,i) = opt_pars(:,i)/median(opt_pars(:,i));
%     plot_pars(:,5+i) = nom_pars(:,i)/median(nom_pars(:,i));
% %     dim(i) = dim(i)/median(opt_pars(:,i));
% %     y(i) = y(i)/median(opt_pars(:,i));
%     
% end
% figure(1)
% hold on
% h = bodimplot(plot_pars,'Color','k','Widths',.35,'Positions',.5:.5:5);
% set(gca,'Yscale','log')
% % plot([.5 1 1.5 2 2.5],dim,'p','Color','b','MarkerSize',25,'MarkerFaceColor','b')
% % plot([.5 1 1.5 2 2.5],y,'p','Color','r','MarkerSize',25,'MarkerFaceColor','r')
% set(gca,'dimTickLabel',{' '})
% set(h,{'linew'},{3})
% % yticks([0 4 8 12 16])
% yticks([1e-1 1 10])
% set(gca,'fontsize',32)
% ylabel('Relative Parameters')
% saveas(figure(1),'bodimplot.eps')
% 
% hiPOTs = [];
% midPOTs = [];
% noPOTs = [];
% figure (1)
% hold on
% 
% 
% 
% for i = 1:5
%     
%     plot_pars(:,i) = opt_pars(:,i);
%     plot_pars(:,5+i) = nom_pars(:,i);
%     
% 
% %     dim(i) = dim(i)/median(opt_pars(:,i));
% %     y(i) = y(i)/median(opt_pars(:,i));
%     
% end
% 
% 
% for i = 1: length(POTS)
%     if POTS(i) == 2
%         hiPOTs = [hiPOTs ; plot_pars(i,1:10), ];
%     
%     elseif POTS(i) == 1
%         midPOTs = [midPOTs ; plot_pars(i,1:10)];
%     else
%         noPOTs = [noPOTs ; plot_pars(i,1:10)];
%     end
% end
% for i=1:10
%     figure(i)
%     hold on
%     grp = [zeros(1,length(hiPOTs(:,i))) ones(1,length(midPOTs(:,i))) 2*ones(1,length(noPOTs(:,i)))];
%     h = bodimplot([hiPOTs(:,i); midPOTs(:,i); noPOTs(:,i)],grp,'Color','k','Widths',.35);
% 
%     set(gca,'dimTickLabel',{' '})
%     set(h,{'linew'},{3})
%     set(gca,'fontsize',32)
%     ylabel('Relative Parameters')
%     saveas(figure(i),strcat('bodimplot',num2str(i),'.eps'))
%     saveas(figure(i),strcat('bodimplot',num2str(i),'.jpg'))
% end

% yticks([0 4 8 12 16])





%% Scatter


% for i = 1:10
%     
%     plot(i*.5*ones(length(hiPOTs(:,i)),1)+.1*ones(length(hiPOTs(:,i)),1),hiPOTs(:,i),'o','Color','b')
%     plot(i*.5*ones(length(midPOTs(:,i)),1)+.1*ones(length(midPOTs(:,i)),1),midPOTs(:,i),'o','Color','b')
%     plot(i*.5*ones(length(noPOTs(:,i)),1),noPOTs(:,i),'o','Color','r')
% 
% end
% dimlim([0,5.5])
% print('scatterboiss','-dpng')
% print('scatterboiss','-depsc2')

%% SVD plotting
dim = 3;

[U, S, V] = svd(log([opt_pars,nom_pars]));
Se = S(1:dim,1:dim);
Ue = U(:,1:dim);
PCA = Ue * Se;
cluster1 = [];
cluster2 = [];
cluster3 = [];




for i = 1: length(clustering)
    if clustering(i) == 1
        cluster1 = [cluster1; PCA(i,1:dim)];
    
    elseif clustering(i) == 3
        cluster3 = [cluster3; PCA(i,1:dim)];
        
    else
        
        cluster2 = [cluster2; PCA(i,1:dim)];
    end
    
end

figure(11)
clf
hold on
%  plot(cluster1(:,1),cluster1(:,2),'o', 'Color','b')
%  plot(cluster2(:,1),cluster2(:,2),'o','Color','r')
%  plot(cluster3(:,1),cluster3(:,2),'o','Color','g')

scatter3(cluster1(:,1),cluster1(:,2),cluster1(:,3),'','b')
% scatter3(cluster3(:,1),cluster3(:,2),cluster3(:,3),'','g')
scatter3(cluster2(:,1),cluster2(:,2),cluster2(:,3),'','r')

figure(10)
clf
hold on
hiPOTs = [];
midPOTs = [];
noPOTs = [];
for i = 1: length(POTS)
    if POTS(i) == 2
        hiPOTs = [hiPOTs ; PCA(i,1:3)];
    
    elseif POTS(i) == 1
        midPOTs = [midPOTs ; PCA(i,1:3)];
    else
        noPOTs = [noPOTs ; PCA(i,1:3)];
    end
end
hold on
% plot(hiPOTs(:,2),hiPOTs(:,3),'o', 'Color','b')
% plot(midPOTs(:,2),midPOTs(:,3),'o','Color','r')
% plot(noPOTs(:,2),noPOTs(:,3),'o','Color','g')
scatter3(hiPOTs(:,1),hiPOTs(:,2),hiPOTs(:,3),'', 'r')
scatter3(midPOTs(:,1),midPOTs(:,2),midPOTs(:,3),'','r')
scatter3(noPOTs(:,1),noPOTs(:,2),noPOTs(:,3),'','b')

%% Coefficient biplot

[coeff,score,latent] = pca(log([opt_pars,nom_pars]));

figure(4)
hold on
biplot(coeff(:,1:dim),'scores',score(:,1:dim),'varlabels',{'tau_pb','tau_s','s_w','s_pb',...
    'H_pr','s_pr','s_s','H_I','H_pb','H_s'});
set(0, 'defaultTextFontSize',18)
print('biplot','-dpng')
print('biplot','-depsc2')

