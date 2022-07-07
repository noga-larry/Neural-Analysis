function data_ss = removeCspkSpikelets(data_ss,data_cs)

REMOVAL_TIME_AFTER_CSPK = 5; %ms
REMOVAL_TIME_BEFORE_CSPK = 1; %ms

[data_ss,data_cs] = reduceToSharedTrials(data_ss,data_cs);
if length(data_ss.trials)==0 || length(data_cs.trials)==0
    disp('Cells were not recorded together')
end

for t=1:length(data_ss.trials)
    removalInd = [];
    CspkTimes = data_cs.trials(t).spike_times;
    SspkTimes = data_ss.trials(t).spike_times;
    for s = 1:length(CspkTimes)
        removalInd = [removalInd, find(SspkTimes<=CspkTimes(s)+REMOVAL_TIME_AFTER_CSPK &...
            SspkTimes>=CspkTimes(s)-REMOVAL_TIME_BEFORE_CSPK)]; 
    end
    keepInd = setdiff(1:length(SspkTimes),removalInd);
    data_ss.trials(t).spike_times = SspkTimes(keepInd);
end
    
end