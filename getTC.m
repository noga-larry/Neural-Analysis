function [TC,pval,h] = getTC(data, directions, ind, comparison_window, ...
    varargin)

% getTC - Calculate the tuning curve of a single neuron and test its
%         significance using the Kruskal Wallis test.
%
% Syntax: [TC,pval,h] = getTC(data, directions, ind, comparison_window, varargin)
%
% Inputs:
%    data - A data structure containing data on this specific cell.
%    directions - A vector of movement directions for which to calculate the
%                 tuning curve.
%    ind - A vector of trial indices to include in the analysis.
%    comparison_window - A time window relative to a trial event onset to
%                        calculate the tuning curve.
%    varargin - Optional input arguments. Can be used to specify:
%               - 'alignTo': the event to which to align the data. The default is
%                 'targetMovementOnset'.
%               - 'test': the statistical test to use for testing the
%                 significance of the tuning curve. The default is
%                 'kruskalwallis'. The options are:
%                 - 'kruskalwallis': for more than 2 directions
%                 - 'bootstraspWelchANOVA': for 2 or more directions
%
% Outputs:
%    TC - A vector containing the firing rate of the neuron for each
%         direction in directions.
%    pval - The p-value of the significance test.
%    h - A logical value indicating whether the null hypothesis of the
%        significance test was rejected.

p = inputParser;
defaultAlignTo= 'targetMovementOnset';
addOptional(p,'alignTo',defaultAlignTo);

defaultTest= 'kruskalwallis';
addOptional(p,'test',defaultTest);

parse(p,varargin{:})
raster_params.align_to = p.Results.alignTo;
test = p.Results.test;


raster_params.time_before = -min(comparison_window);
raster_params.time_after = max(comparison_window);
raster_params.smoothing_margins = 0;

if ischar(ind) && strcmp(ind,'all')
   ind = 1:length(data.trials);
end
% get direcions

[~,match_d] = getDirections(data,ind);

% indices of failed trials
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

switch test
    case 'kruskalwallis'
        pval = kruskalwallis(spikes,group,'off');
    case 'bootstraspWelchANOVA'
        pval = bootstraspWelchANOVA(spikes', group');
end

h = pval<0.05;


end
