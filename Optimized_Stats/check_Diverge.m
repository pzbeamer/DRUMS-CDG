num_rand_starts = 8;
load('flagDiverge.mat')

can_take_med=zeros(5,length(flagDiverge));

for index=1:length(flagDiverge)
    load(strcat(flagDiverge{index},'_optimized.mat'))
    flagDiverge{index}
    for ps=1:5
        ct=0;
        med=median(saveDat.optpars(:,ps));
        for k=1:8
            if saveDat.optpars(k,ps)<med*.8 || saveDat.optpars(k,ps)>med*1.2
                ct=ct+1;
            end
        end
        can_take_med(ps,index)=ct;
    end
end

ctt=1;
for index=1:length(flagDiverge)
    load(strcat(flagDiverge{index},'_optimized.mat'))
    flagDiverge{index}
    bad=find(can_take_med(:,index)>3);
    if ~isempty(bad)
        bad_for_med{1,ctt}=length(bad);
        bad_for_med{2,ctt}=can_take_med(:,index);
        bad_for_med{3,ctt}=flagDiverge{index};
        ctt=ctt+1;
    end
end

        
    