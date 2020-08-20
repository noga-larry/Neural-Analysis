function [TC,p,h] = getTC(data,  directions, ind, comparison_window)

% This function finds the preferred directio of a cell using center of mass
% and checks its significance using either ranksum test (only 2 directions)
% or Kruskal Wallis test (more than 2).
% Inputs: data                a data structer containing data on this 
%                             specific cell.
%         raster_params 
%           .time_before       Ms, time before the event in .allign_to
%           .time_after        Ms, time after  the event in .allign_to
%           .smoothing_margins Size of additional margins to avoid edge 
%                              effects in smoothing.
%           .iclude_failed     1: include failed trials, 0: don't 
%           .TC_window         Time window relative to movement onset to 


raster_params.time_before = -min(comparison_window);
raster_params.time_after = max(comparison_window);
raster_params.smoothing_margins = 0;
raster_params.align_to = 'targetMovementOnset';

% get direcions

[~,match_d] = getDirections(data,ind);

% indices of failsed trials
fail_bool = [data.trials.fail];

% preallocate
TC = nan(length(directions),1); 
spikes =[];
group ={};


for d = 1:length(directions)
    % get relevent indices
    dir_bool = (match_d==directions(d));
    indDir = find(dir_bool.*(~fail_bool));
    indDir = intersect(indDir, ind);
    % create raster
    raster =  getRaster(data, indDir, raster_params);
    spikes = [spikes sum(raster,1)];
    [group{(end+1):(end+length(indDir))}]= deal(num2str(directions(d)));
    TC(d) = mean(mean(raster))*1000; %in spk/s
    
end

% significance test

p = kruskalwallis(spikes,group,'off');
h = p<0.05;


end
