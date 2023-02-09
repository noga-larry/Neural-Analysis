function FR = getFR(data,ind,alignTo,timeBefore,timeAfter)

raster_params.align_to = alignTo;
raster_params.smoothing_margins = 0;
raster_params.time_before = timeBefore;
raster_params.time_after = timeAfter;

raster = getRaster(data, ind, raster_params);

FR = mean(raster,'all')*1000;