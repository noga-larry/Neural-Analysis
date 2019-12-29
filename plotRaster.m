function plotRaster (raster, raster_params, color)

ts = -raster_params.time_before:raster_params.time_after;
raster = raster (raster_params.smoothing_margins+1: end -raster_params.smoothing_margins,:);
[x,y] = find(raster); x = ts(x);

if  (mean(mean(raster))*1000)/size(raster,2) > 1.5
    markerSize = 0.001;
else
    markerSize = 6;
end

if exist('color','var')
    plot (x,y,['.' color ],'MarkerSize',markerSize); 
else
    plot (x,y,'.','MarkerSize',markerSize);
end

xlim ([-raster_params.time_before,raster_params.time_after])

if (sum(sum(raster)))>0
    ylim ([0, size(raster,2)])
end

