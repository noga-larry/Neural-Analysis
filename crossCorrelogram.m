function cc = crossCorrelogram(data1,data2,runningWindow)

raster_params.align_to = 'all';

[data1,data2] = reduceToSharedTrials(data1,data2);

if length(data1.trials)==0 || length(data2.trials)==0
    disp('Cells were not recorded together')
end

cc = zeros(size(runningWindow));
spikeCounter = 0;
for t=1:length(data1.trials)
    raster1 = getRaster(data1, t, raster_params);
    raster2 = getRaster(data2, t, raster_params);
    spikeBins = find(raster1);
    spikeBins = spikeBins(spikeBins>(-min(runningWindow))& ...
        spikeBins<(length(raster2)-max(runningWindow)));
    for i=1:length(spikeBins)
        spikeCounter = spikeCounter+1;
        cc = cc + raster2(spikeBins(i)+runningWindow)';
    end
end

cc = (cc/spikeCounter)*1000;