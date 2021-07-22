
clear all
T=readtable('../Summary_Data_800_Gals/PatientInfo07192021.csv');
load('../AStract/potspats.mat')
load('../Cluster/Markers/markers.mat')
guy = 1;
for pt = 3:872 
    
    pt_id = T{pt,1}{1}
    
    if isfile(strcat('../Optimized/',pt_id,'_optimized.mat'))
        load(strcat('../Optimized/',pt_id,'_optimized.mat'))

        if ~any(saveDat.flag)
            ind=find(saveDat.error==min(saveDat.error));
<<<<<<< HEAD
            opt_pars(guy,1:5) = saveDat.optpars(ind,1:5);
            %opt_pars(guy,1:5) = saveDat.optpars(1,1:5);
            opt_pars(guy,1:10) = markers(pt-3,2:11);
            opt_pars(guy,1:5) = saveDat.optpars(1,1:5);
            %opt_pars(guy,6:7) = barkers(pt-3,:);
=======

            opt_pars(guy,1:5) = saveDat.optpars(1,1:5);
            %opt_pars(guy,1:10) = markers(pt-3,2:11);
            

>>>>>>> 4cc2055a06344306e82ce67a082f16b56edbffa0
            guy = guy +1;
            
            if ~isempty(pots_pats(pt-2))
            
                ppl(guy) = 1;
                
            else 
                ppl(guy) = 0;
            end 
            
        else
    
        end
        
    end

end

%% Cluster
<<<<<<< HEAD
 stuff = kmeans(opt_pars,2);
=======
<<<<<<< HEAD
stuff = kmeans(opt_pars,2);
%stuff = dbscan(opt_pars,9,20);
figure(1);
silhouette(opt_pars,stuff);
figure(2);
plot(opt_pars(:,1),opt_pars(:,2),'o')
=======
% stuff = kmeans(opt_pars,2);
>>>>>>> f48d97be3c111a041bc35af0135749842cae9f7d
% %stuff = dbscan(opt_pars,9,20);
% figure(1);
% silhouette(opt_pars,stuff);
%figure(2);
%plot(opt_pars(:,1),opt_pars(:,2),'o')
<<<<<<< HEAD
%% Boxplots

% for i = 1:5
%     
%     figure(i+5)
%     boxplot(opt_pars(:,i),'Whisker',20)
% 
% end


%% SVD plotting
=======
for i = 1:5
    
    figure(i+5)
    boxplot(opt_pars(:,i),'Whisker',20)
>>>>>>> 4cc2055a06344306e82ce67a082f16b56edbffa0
>>>>>>> f48d97be3c111a041bc35af0135749842cae9f7d

figure(10)
hold on
[U, S, V] = svd(opt_pars);
Se = S(1:2,1:2);
Ue = U(:,1:2);
pp = Ue * Se;

for i = 1: length(stuff)
    if stuff(i) == 2
        bb(i,1:2) = pp(i,1:2);
        
    else
        rr(i,1:2) = pp(i,1:2);
    end
end

plot(bb(:,1),bb(:,2),'o', 'Color','b')
plot(rr(:,1),rr(:,2),'o','Color','r')
