function [avejPSTHraw,avejPSTHprod,aveIndependentExpectation] = jPSTH(data1,data2,indSets,raster_params)

for s = 1:length(indSets)
    ind = indSets{s};
    
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
    
    disp([num2str(data2.info.cell_ID) ': Fraction of bins with more then 1 spk: '...
        num2str(mean(mean(binnedRaster2>1)))]);
        
    jPSTHraw(s,:,:) = binnedRaster1 * binnedRaster2' /size(binnedRaster1,2);
    
    % independent cells prediction
    
    independentExpectation(s,:,:) = mean(binnedRaster1,2)*mean(binnedRaster2,2)';
    D1 = std(binnedRaster1,1,2);
    D2 = std(binnedRaster2,1,2);
    normalization = sqrt(D1*D2');
    jPSTHprod(s,:,:) =  squeeze(jPSTHraw(s,:,:) - independentExpectation(s,:,:))./normalization;
    
    
end
avejPSTHraw = squeeze(nanmean(jPSTHraw,1));
avejPSTHprod = squeeze(nanmean(jPSTHprod,1));
aveIndependentExpectation = squeeze(nanmean(independentExpectation,1));

raster1 = getRaster(data1,cat(2,indSets{:}),raster_params);
raster2 = getRaster(data2,cat(2,indSets{:}),raster_params);

if raster_params.plot_cell == 1
    
   
   subplot(3,2,1)
   plotRaster(raster1, raster_params)
   title('Cell #1')
   
   subplot(3,2,2)
   plotRaster(raster2, raster_params)
   title('Cell #2')
   
   ts = -raster_params.time_before:raster_params.bin_size:raster_params.time_after;
   
   subplot(3,2,3)
   imagesc(ts,ts,squeeze(nanmean(jPSTHraw))); colorbar
   title ('Raw jPSTH')
   
   subplot(3,2,4)
   imagesc(ts,ts,aveIndependentExpectation); colorbar
   title ('Prod')
   
   subplot(3,2,5)
   imagesc(ts,ts,squeeze(nanmean(jPSTHraw-independentExpectation))); colorbar
   title ('Raw jPSTH-Prod')
   
   subplot(3,2,6)
   imagesc(ts,ts,avejPSTHprod); colorbar
   title ('Raw jPSTH-Prod / normaliztion')   
end

end

