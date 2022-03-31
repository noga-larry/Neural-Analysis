function plotRaster (raster, raster_params, varargin)


MARKER_SIZE = 1;

ts = -raster_params.time_before:raster_params.time_after;
raster = raster (raster_params.smoothing_margins+1: end -raster_params.smoothing_margins,:);
[x,y] = find(raster); x = ts(x);


if any(cellfun(@isnumeric,varargin))
    conditions = varargin{find(cellfun(@isnumeric,varargin))};
else
    conditions = zeros(1,size(raster,2));
end

unique_cond = unique(conditions);

if any(cellfun(@ischar,varargin))
    colors = varargin{find(cellfun(@ischar,varargin))};
else
    colors = varycolor(length(unique_cond));
end

y_0 = [0, find(diff(conditions)), length(conditions)];

hold on
for i=1:length(unique_cond)
    inx = find(conditions==unique_cond(i));
    [x,y] = find(raster(:,inx)); x = ts(x);
    plot (x,y+y_0(i),'.','MarkerSize',MARKER_SIZE,'Color',colors(i,:)); 
end
hold off

xlim ([-raster_params.time_before,raster_params.time_after])

if sum(raster,'all')>0
    ylim ([0, size(raster,2)])
end

xlabel(['Time from ' raster_params.align_to ' (ms)'])


