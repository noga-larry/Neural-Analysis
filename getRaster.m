function raster = getRaster(data, ind, raster_params)
% Ths function caculates the raster of a specific cell in specified trials
% either alligned to an event or simply the entire trial.
% Inputs: data                a data structer containing data on this
%                             specific cell.
%         raster_params
%           .cue_time          Ms, time the target changes color
%           .time_before       Ms, time before  the event in .allign_to
%           .time_after        Ms, time after  the event in .allign_to
%           .allign_to         The event in the trial to which to allign the
%                              data to ('cue', 'targetMovementOnset',
%                              'reward', 'all')
%           .smoothing_margins size of additional margins to avoid edge
%                              effects in smoothing, in later calculation
%                              of PSTH.
%         ind                  Indices of the relevent trials
% Output: raster               raster (time x length(ind))

% Note: Alligning to 'all' wll return the raster of the entire trial. If
% ind contains more thrn one trial and trials have different lengths this
% may cause a problem.
EXTENDED_TIME_AFTER_TRIAL = 5001;

if ~any(strcmp(raster_params.align_to,{'all','allExtended'}))
    window = -(raster_params.time_before+raster_params.smoothing_margins):...
        (raster_params.time_after+raster_params.smoothing_margins);
    display_time = raster_params.time_before + raster_params.time_after+1;
    raster = zeros (display_time+2*raster_params.smoothing_margins,length(ind));
    alignment_times = alignmentTimesFactory(data,ind,raster_params.align_to);    
end

for f = 1:length(ind)
    
    switch raster_params.align_to
        
        case 'reward'
            raster (:,f) = times2Binary(data.trials(ind(f)).extended_spike_times...
                ,alignment_times(f),...
                window);
            
        case 'all'
            
            raster (:,f) = times2Binary(data.trials(ind(f)).spike_times...
                ,0,...
                1:data.trials(ind(f)).trial_length);
            
        case 'allExtended'
            len = data.trials(ind(f)).trial_length...
                +EXTENDED_TIME_AFTER_TRIAL+...
                data.trials(ind(f)).extended_trial_begin;
            raster (:,f) = times2Binary(data.trials(ind(f)).extended_spike_times...
                ,0,...
                1:len);
        
        otherwise
            raster (:,f) = times2Binary(data.trials(ind(f)).spike_times...
                ,alignment_times(f),...
                window);
    end
end

end

