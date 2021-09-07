function data = removeCspkDoubleDetections(data)

MINIMAL_INTERVAL = 7; %ms

for t=1:length(data.trials)
    CspkTimes = data.trials(t).spike_times;
    % Remove the second duplicate
    indRemove = find(diff(CspkTimes)<=MINIMAL_INTERVAL)+1;
    indKeep = setdiff(1:length(CspkTimes),indRemove);
    data.trials(t).spike_times = CspkTimes(indKeep);
end

end