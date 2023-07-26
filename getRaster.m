function raster = getRaster(data, ind, raster_params)
% getRaster calculates the raster of a specific cell in specified trials,
% either aligned to an event or the entire trial.
%
% Inputs:
%   data - A data structure containing data on the specific cell.
%   ind - Indices of the relevant trials.
%   raster_params - Parameters for raster calculation.
%     .time_before - Time before the event in 'align_to', in milliseconds.
%     .time_after - Time after the event in 'align_to', in milliseconds.
%     .align_to - The event in the trial to which the data should be aligned
%                 ('cue', 'targetMovementOnset', 'reward', 'all').
%     .smoothing_margins - Size of additional margins to avoid edge effects
%                          in smoothing during calculation of PSTH.
%
% Output:
%   raster - The raster matrix (time x length(ind)).
%
% Note: Aligning to 'all' will return the raster of the entire trial. If 'ind'
% contains more than one trial and trials have different lengths, this may cause
% a problem.
%
% The 'allExtended' option extends the raster to include an additional margin
% after the trial ('EXTENDED_TIME_AFTER_TRIAL') and aligns it to the start of
% the extended trial.

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

