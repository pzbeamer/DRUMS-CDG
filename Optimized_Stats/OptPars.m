
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

            opt_pars(guy,1:5) = saveDat.optpars(1,1:5);
            %opt_pars(guy,1:10) = markers(pt-3,2:11);
            

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
% stuff = kmeans(opt_pars,2);
% %stuff = dbscan(opt_pars,9,20);
% figure(1);
% silhouette(opt_pars,stuff);
%figure(2);
%plot(opt_pars(:,1),opt_pars(:,2),'o')
for i = 1:5
    
    figure(i+5)
    boxplot(opt_pars(:,i),'Whisker',20)

end
