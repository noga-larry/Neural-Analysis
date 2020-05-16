function[psth] = raster2STpsth(raster,params) 

psth = nan(size(raster,2),params.time_before+params.time_after+1);

for t = 1:size(raster,2)
    psth(t,:) = raster2psth(raster(:,t),params);
end
    
