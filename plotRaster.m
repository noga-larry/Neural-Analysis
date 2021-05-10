function plotRaster (raster, raster_params, color)


MARKER_SIZE = 1;

ts = -raster_params.time_before:raster_params.time_after;
raster = raster (raster_params.smoothing_margins+1: end -raster_params.smoothing_margins,:);
[x,y] = find(raster); x = ts(x);


if exist('color','var')
    plot (x,y,['.' color ],'MarkerSize',MARKER_SIZE); 
else
    plot (x,y,'.','MarkerSize',MARKER_SIZE);
end

xlim ([-raster_params.time_before,raster_params.time_after])

if (sum(sum(raster)))>0
    ylim ([0, size(raster,2)])
end

