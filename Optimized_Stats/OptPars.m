
clear all
close all
%We need patient info, markers,and which patients have pots
T=readtable('../Summary_Data_800_Gals/PatientInfo07212021.csv');
load('../AStract/potspats.mat')
load('../Cluster/Markers/markers.mat')
counter = 1;
T2{1,1} = 'File Names';
T2{1,2} = 'Estimated Tau_p';
T2{1,3} = 'Estimated Tau_s';
T2{1,4} = 'Estimated s_w';
T2{1,5} = 'Estimated s_p';
T2{1,6} = 'Estimated H_R';
T2{1,7} = 'Calculated s_r';
T2{1,8} = 'Calculated s_s';
T2{1,9} = 'Calculated H_I';
T2{1,10} = 'Calculated H_p';
T2{1,11} = 'Calculatd H_s';
T2{1,12} = 'Alpha';
T2{1,13} = 'Beta';
T2{1,14} = 'Gamma';
T2{1,15} = 'HRbeforeVal';
T2{1,16} = 'HRafterVal';
T2{1,17} = 'SBPbeforeVal';
T2{1,18} = 'SBPafterVal';
T2{1,19} = 'SP max phase 1';
T2{1,20} = 'SP at end on phase 1';
T2{1,21} = 'SP min phase 2';

%Go through each row of PatientInfo
for pt = 3:872
    
    %patient id
    pt_id = T{pt,1}{1}
    T2{pt,1} = pt_id;
    
        
    % If they have an optimized file
    if isfile(strcat('../Optimized/',pt_id,'_optimized.mat'))
        
        load(strcat('../Optimized/',pt_id,'_optimized.mat'))
        
        %Grab patients for plotting
        if pt == 9
            x = saveDat.optpars(1,:);
        elseif pt == 23
            y = saveDat.optpars(1,:);
        end
        
        try 
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
                nom_pars(counter,1:5) = saveDat.parsfull(1,[16 17 18 19 21]);
                tones(counter,1)      = max(saveDat.symp(1,:));
                tones(counter,2)      = max(saveDat.para(1,:));
                markers(counter,1:16) = markerdat.markers(pt,:);

                % Make table
                for i = 1:15
                    if i < 6
                        T2{pt,1+i} = opt_pars(counter,i);
                        T2{pt,6+i} = nom_pars(counter,i);
                    end
                    T2{pt,11+i} = markers(counter,i);
                end
                %Increment
                counter = counter +1;


            else
                
            end
        catch
            
        end
    end
end
%% Cluster (self explanatory)

%Cluster optimal parameters, nominal parameters, and max tones (excluding
%bad data)
good = [];
for i = 1:length(nom_pars(:,1))
    
    if min(nom_pars(i,:)) > 0 && min(markers(i,:)) > 0
        
        good = [good; i];
        
    end
    
end
 p = [opt_pars(good,:),...
     nom_pars(good,:),...
     tones(good,:),...
     markers(good,:)];


%p = opt_pars;
clustering = kmeans(log(p),2);


POTS = POTS(good);
save('4plots.mat','opt_pars','POTS','clustering','nom_pars','tones','p','markers')


