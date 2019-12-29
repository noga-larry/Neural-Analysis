function [jPSTHraw,jPSTHprod] = jPSTH(data1,data2,ind,raster_params)

raster1 = getRaster(data1,ind,raster_params);
raster2 = getRaster(data2,ind,raster_params);

% bining

raster1 = raster1(1:(size(raster1,1)-rem(size(raster1,1),raster_params.bin_size)),:);
binnedRaster1 = reshape(raster1,raster_params.bin_size,size(raster1,1)...
    /raster_params.bin_size,size(raster1,2));
binnedRaster1 = squeeze(sum(binnedRaster1));

raster2 = raster2(1:(size(raster2,1)-rem(size(raster2,1),raster_params.bin_size)),:);
binnedRaster2 = reshape(raster2,raster_params.bin_size,size(raster2,1)...
    /raster_params.bin_size,size(raster2,2));
binnedRaster2 = squeeze(sum(binnedRaster2));


% check fraction of bins with more than 1 spk

disp([num2str(data1.info.cell_ID) ': Fraction of bins with more then 1 spk: '...
    num2str(mean(mean(binnedRaster1>1)))]);

binnedRaster1 = (binnedRaster1>0);

disp([num2str(data2.info.cell_ID) ': Fraction of bins with more then 1 spk: '...
    num2str(mean(mean(binnedRaster2>1)))]);

binnedRaster2 = (binnedRaster2>0);

jPSTHraw = binnedRaster1 * binnedRaster2'/size(binnedRaster1,2);

% independent cells prediction

independentExpectation = mean(binnedRaster1,2)*mean(binnedRaster2,2)';
D1 = std(binnedRaster1,1,2);
D2 = std(binnedRaster2,1,2);
normalization = sqrt(D1*D2');
jPSTHprod =  (jPSTHraw - independentExpectation)./normalization;

if raster_params.plot_cell == 1
    
    
    subplot(1,2,1)
    imagesc(jPSTHraw)
    title ('Raw jPSTH')
    
    subplot(1,2,2)
    imagesc(jPSTHprod)
    title ('jPSTH - Prod')
    
    suptitle ([data1.info.cell_type '\' data1.info.cell_type ])
    
end

end

