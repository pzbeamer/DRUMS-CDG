
clear all
close all
%We need patient info, markers,and which patients have pots
T=readtable('../Summary_Data_800_Gals/PatientInfo07212021.csv');
load('../AStract/potspats.mat')
load('../Cluster/Markers/markers.mat')
counter = 1;


%Go through each row of PatientInfo
for pt = 3:872
    
    %patient id
    pt_id = T{pt,1}{1}
    
        
    % If they have an optimized file
    if isfile(strcat('../Optimized/',pt_id,'_optimized.mat'))
        
        load(strcat('../Optimized/',pt_id,'_optimized.mat'))
        
        %Grab patients for plotting
        if pt == 9
            x = saveDat.optpars(1,:);
        elseif pt == 23
            y = saveDat.optpars(1,:);
        end
        
        
        %Discard flagged optimizations
        if ~any(saveDat.flag)
            
            
            % Check if they have tachycardia marked in spreadsheet and
            % record
            if ~isnan(T{pt,90}) && ~isnan(T{pt,91})
                
                POTS(counter) = max(T{pt,90},T{pt,91});
                
            elseif ~isnan(T{pt,90})
                
                POTS(counter) = T{pt,90};
               
            elseif ~isnan(T{pt,91})
                
                POTS(counter) = T{pt,91};
               
            else
                
                POTS(counter) = 0;
                
            end
            
            %Record optimized data for clustering
            %We can take the first random start since they converge (no
            %flags)
            opt_pars(counter,1:5) = saveDat.optpars(1,1:5);
            
            %opt_pars(counter,1:5) = saveDat.optpars(1,1:5);
            %opt_pars(counter,6:7) = barkers(pt-3,:);
            %opt_pars(counter,1:10) = markers(pt-3,2:11);
            
            %Increment
            counter = counter +1;
            
            
        else
    
        end
        
    end

end
%Save for Justen
save('4plots.mat','opt_pars','POTS')
%% Cluster (self explanatory)


 stuff = kmeans(opt_pars,2);
    
% % %stuff = dbscan(opt_pars,9,20);
% % figure(1);
% % silhouette(opt_pars,stuff);
% %figure(2);
% %plot(opt_pars(:,1),opt_pars(:,2),'o')
%% Boxplots

for i = 1:5
    
    plot_pars(:,i) = opt_pars(:,i)/median(opt_pars(:,i));
    x(i) = x(i)/median(opt_pars(:,i));
    y(i) = y(i)/median(opt_pars(:,i));
    
end
figure(1)
hold on
h = boxplot(plot_pars,'Whisker',20,'Color','k','Widths',.35,'Positions',[.5 1 1.5 2 2.5]);
plot([.5 1 1.5 2 2.5],x,'p','Color','b','MarkerSize',25,'MarkerFaceColor','b')
plot([.5 1 1.5 2 2.5],y,'p','Color','r','MarkerSize',25,'MarkerFaceColor','r')
set(gca,'XTickLabel',{' '})
set(h,{'linew'},{3})
yticks([0 4 8 12 16])
set(gca,'fontsize',32)
ylabel('Relative Parameters')
saveas(figure(1),'boxplot.eps')

%% SVD plotting


[U, S, V] = svd(opt_pars);
Se = S(1:3,1:3);
Ue = U(:,1:3);
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
%         cluster2 = [cluster2; PCA(i,1:3)];
%     end
%     
% end
% 
% figure(10)
% clf
% hold on
% %  plot(cluster1(:,2),cluster1(:,3),'o', 'Color','b')
% %  plot(cluster2(:,2),cluster2(:,3),'o','Color','r')
% scatter3(cluster1(:,1),cluster1(:,2),cluster1(:,3),'','b')
% scatter3(cluster2(:,1),cluster2(:,2),cluster2(:,3),'','r')

plot = [];
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
scatter3(hiPOTs(:,1),hiPOTs(:,2),hiPOTs(:,3),'', 'b')
scatter3(midPOTs(:,1),midPOTs(:,2),midPOTs(:,3),'','r')
scatter3(noPOTs(:,1),noPOTs(:,2),noPOTs(:,3),'','g')
