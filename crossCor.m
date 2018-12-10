function aveCorTrace  = crossCor(data1,data2,params)
% This function calculates the cross corelation of two cells: data1 and
% data2. A cross corelation is essentialy a PSTH of one cell alli
% Note: The cross correlation is not symmetric!
% Inputs:     data1   Data structure for the first cell.
%             data1   Data structure for the second cell.
%             params  Parameters for calculation:
%               .params.max_dt
%                     Maximal time diference to look at.                        


raster_params.allign_to = 'all'; 
window = -params.max_dt:params.max_dt;
corTrace = zeros (length(window),1);
spk_count = 1;
%This function calsulates the cross correlation between two data sets.
for ii=1:length(data1.trials)
   	jj = find(strcmp(data1.trials(ii).maestro_name,{data2.trials.maestro_name}));
    if isempty(jj)
        continue
    end
    raster1 = getRaster( data1, ii, raster_params );
    raster2 = getRaster( data2, jj, raster_params );
    spks = find (raster1);
    % remove spk in edges:
    spks(spks<(params.max_dt+1))= [];
    spks(spks>(data1.trials(ii).trial_length-params.max_dt))= [];
    
    for s = 1:length(spks)
        
        corTrace(:,spk_count) = raster2(spks(s)+window);
        spk_count = spk_count+1;
    end
        
end

aveCorTrace = mean(corTrace,2)*1000;