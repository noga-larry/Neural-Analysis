function plotRaster (raster, raster_params)
 ts = -raster_params.time_before:raster_params.time_after;
 raster = raster (raster_params.smoothing_margins+1: end -raster_params.smoothing_margins,:); 
 [x,y] = find(raster); x = ts(x);
 plot (x,y,'.'); hold on
 xlim ([-raster_params.time_before,raster_params.time_after])
 ylim ([1, size(raster,2)])