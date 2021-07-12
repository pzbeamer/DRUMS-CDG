function plotsensitivities
clear all
pb = [20 22 27 28 32 33 34 41 45];
Snormv1 = zeros(22,10);
Snormv2 = zeros(22,10);
for jkl = 1:9
    load(strcat('sens',pt_id,'.mat'));
    sens_norm1 = sens_norm;
    load(strcat('sens',num2str(pb(jkl)),'_2.mat'));
    sens_norm2 = sens_norm;
    Snormv1(:,jkl) = sens_norm1'/max(sens_norm1);
    Snormv2(:,jkl) = sens_norm2'/max(sens_norm1);
end
for jkl = 1:22
    avgsv1(jkl) = mean(Snormv1(jkl,:));
    avgsv2(jkl) = mean(Snormv2(jkl,:));
    errv1(jkl) = std(Snormv1(jkl,:))/sqrt(length(pb));
    errv2(jkl) = std(Snormv2(jkl,:))/sqrt(length(pb));
end

[~,paramsens] = sort(avgsv1,'descend');
avgsv1 = avgsv1(paramsens);
avgsv2 = avgsv2(paramsens);

hold on 

set(gcf,'units','normalized','outerposition',[0 0 .75 .75]);
set(gcf,'renderer','Painters')
set(gca,'FontSize',25)
xlim([0 length(paramsens)+1])
%grid on
ylabel('Ranked Sensitivities')
xlabel('Parameters')
%title('Ranked Relative Sensitivities')
Xtick = 1:length(paramsens);
set(gca,'xtick',Xtick)
set(gca,'TickLabelInterpreter','latex')
Xlabel = params(paramsens); 
set(gca,'XTickLabels',Xlabel)
set(gca,'YScale','log')
set(gca,'XTickLabels',Xlabel)
ylim([1e-3 1])
ytick = [1e-3 1e-2 1e-1 1]; 

hold on
set(gca,'FontSize',25)
%     
% txt = '$\eta_1$'; 
% text(24,8e-2,txt,'interpreter','latex','FontSize',40)
% txt = '$\eta_2$'; 
% text(24,8e-4,txt,'interpreter','latex','FontSize',40)

% print(hfig1,'-depsc2','LSA.eps')
% print(hfig1,'-dpng','LSA.png') 
avgsv1
errv1
e1 = errorbar([1:length(Rsens)],avgsv1,errv1,'o','MarkerFaceColor','m','MarkerSize',15);
e1.Color = 'm';
e1.LineWidth = 1;
e2 = errorbar([1:length(Rsens)],avgsv2,errv2,'o','MarkerFaceColor','b','MarkerSize',15);
e2.Color = 'b';
e2.LineWidth = 1;
legend('Valsalva 1','Valsalva 2');


end