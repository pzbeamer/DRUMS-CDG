
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
<<<<<<< HEAD
            ind=find(saveDat.error==min(saveDat.error));
            opt_pars(guy,1:5) = saveDat.optpars(ind,1:5);
=======
            
<<<<<<< HEAD
            %opt_pars(guy,1:5) = saveDat.optpars(1,1:5);
            opt_pars(guy,1:10) = markers(pt-3,2:11);
=======
            opt_pars(guy,1:5) = saveDat.optpars(1,1:5);
            opt_pars(guy,6:7) = barkers(pt-3,:);
>>>>>>> a1fba088ef8350aad17af251458b51c7bc539c55
>>>>>>> 8f94237bea5271471309bfdb029ed5de53dad5b7
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
stuff = kmeans(opt_pars,2);
%stuff = dbscan(opt_pars,9,20);
figure(1);
silhouette(opt_pars,stuff);
%figure(2);
%plot(opt_pars(:,1),opt_pars(:,2),'o')




