function psth = getSTPSTH (data, ind, raster_params)
         
raster = getRaster(data, ind, raster_params);
psth = raster2STpsth(raster,raster_params);