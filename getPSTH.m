function psth = getPSTH ( data, ind, raster_params);
         
raster = getRaster( data, ind, raster_params );
psth = raster2psth(raster,raster_params );