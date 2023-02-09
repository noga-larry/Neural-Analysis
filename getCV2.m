function CV2 = getCV2(data,ind,alignTo,timeBefore,timeAfter)

raster_params.align_to = alignTo;
raster_params.smoothing_margins = 0;
raster_params.time_before = timeBefore;
raster_params.time_after = timeAfter;

raster = getRaster(data, ind, raster_params);
CV2PerTrial = nan(1,length(ind));
for t = 1:length(ind)
    spikesInTime = find(raster(:,t));
    ISI = spikesInTime(2:end)-spikesInTime(1:end-1);
    CV2PerTrial(t) = 2*mean(abs(ISI(2:end) - ISI(1:end-1))./(ISI(2:end) + ISI(1:end-1)));
    
end

CV2= mean(CV2PerTrial,'omitnan');
if mean(isnan(CV2PerTrial))>0.5
    disp(['CV2: Nans - ' num2str(mean(isnan(CV2PerTrial)))])
end