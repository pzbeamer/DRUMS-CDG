
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
%% Cluster (self explanatory)


stuff = kmeans(opt_pars,2);


save('4plots.mat','opt_pars','POTS','stuff')


