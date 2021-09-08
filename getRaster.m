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

window = -(raster_params.time_before+raster_params.smoothing_margins):...
    (raster_params.time_after+raster_params.smoothing_margins);
display_time = raster_params.time_before + raster_params.time_after+1;
raster = zeros (display_time+2*raster_params.smoothing_margins,length(ind));
for f = 1:length(ind)
    
    switch raster_params.align_to
        
        case 'cue'
            raster (:,f) = times2Binary(data.trials(ind(f)).spike_times...
                ,data.trials(ind(f)).cue_onset,...
                window,...
                data.trials(ind(f)).trial_length);
            
            
        case 'targetMovementOnset'

                raster (:,f) = times2Binary(data.trials(ind(f)).spike_times...
                    ,data.trials(ind(f)).movement_onset,...
                    window,...
                    data.trials(ind(f)).trial_length);
        case 'reward'
            if ~ isnan(data.trials(ind(f)).rwd_time_in_extended)
                
                raster (:,f) = times2Binary(data.trials(ind(f)).extended_spike_times...
                    ,data.trials(ind(f)).rwd_time_in_extended,...
                    window,...
                    data.trials(ind(f)).rwd_time_in_extended...
                    +EXTENDED_TIME_AFTER_TRIAL);
            else
                raster (:,f) = nan(length(window),1);
                
            end
            
        case 'all'
            
            raster (:,f) = times2Binary(data.trials(ind(f)).spike_times...
                ,0,...
                1:data.trials(ind(f)).trial_length,...
                data.trials(ind(f)).trial_length);
        
        case 'allExtended'
            len = data.trials(ind(f)).trial_length...
                +EXTENDED_TIME_AFTER_TRIAL+...
                data.trials(ind(f)).extended_trial_begin;
            raster (:,f) = times2Binary(data.trials(ind(f)).spike_times...
                ,0,...
                1:len,...
                len);
    end
end

end

