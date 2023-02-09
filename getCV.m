function CV = getCV(data,ind,alignTo,timeBefore,timeAfter)

raster_params.align_to = alignTo;
raster_params.smoothing_margins = 0;
raster_params.time_before = timeBefore;
raster_params.time_after = timeAfter;

raster = getRaster(data, ind, raster_params);
CVPerTrial = nan(1,length(ind));
for t = 1:length(ind)
    spikesInTime = find(raster(:,t));
    ISI = spikesInTime(2:end)-spikesInTime(1:end-1);
    CVPerTrial(t) = std(ISI)/mean(ISI);
    
end

CV= mean(CVPerTrial,'omitnan');
if mean(isnan(CVPerTrial))>0.5
    disp(['CV: Nans - ' num2str(mean(isnan(CVPerTrial)))])
   
end
end