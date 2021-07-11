function raster = getRaster( data, ind, raster_params )
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
display_time = raster_params.time_before + raster_params.time_after+1;

switch raster_params.align_to
    case 'cue'
        
        raster = zeros (display_time+2*raster_params.smoothing_margins,length(ind));
        
        for f = 1:length(ind)
            ts = data.trials(ind(f)).cue_onset +(-(raster_params.time_before+raster_params.smoothing_margins):...
                (raster_params.time_after+raster_params.smoothing_margins));
            ind_spk = ceil(data.trials(ind(f)).spike_times);
            ind_spk(ind_spk==0) = 1; % if spike is at time 0, move to 1.
            raster_t = zeros (data.trials(ind(f)).trial_length,1);
            raster_t(ind_spk) = 1;
            raster_t = raster_t (ts);
            raster (:,f) = raster_t;
        end
        
    case 'targetMovementOnset'
        
        raster = zeros (display_time+2*raster_params.smoothing_margins,length(ind));
        
        
        for f = 1:length(ind)
            ts = data.trials(ind(f)).movement_onset +(-(raster_params.time_before+raster_params.smoothing_margins):...
                (raster_params.time_after+raster_params.smoothing_margins));
            ind_spk = ceil(data.trials(ind(f)).spike_times);
            ind_spk(ind_spk==0) = 1; % if spike is at time 0, move to 1.
            raster_t = zeros (data.trials(ind(f)).trial_length,1);
            raster_t(ind_spk) = 1;
            raster_t = raster_t (ts);
            raster (:,f) = raster_t;
        end
        
    case 'reward'
        
        raster = zeros (display_time+2*raster_params.smoothing_margins,length(ind));
        
        for f = 1:length(ind)
            if ~ isnan(data.trials(ind(f)).rwd_time_in_extended)
                ts = data.trials(ind(f)).rwd_time_in_extended +(-(raster_params.time_before+raster_params.smoothing_margins):...
                    (raster_params.time_after+raster_params.smoothing_margins));
                ind_spk = ceil(data.trials(ind(f)).extended_spike_times);
                ind_spk(ind_spk==0) = 1; % if spike is at time 0, move to 1.
                raster_t = zeros (data.trials(ind(f)).rwd_time_in_extended+EXTENDED_TIME_AFTER_TRIAL,1);
                raster_t(ind_spk) = 1;
                raster_t = raster_t (ts);
                raster (:,f) = raster_t;
            else
                raster (:,f) = nan(length(-(raster_params.time_before+raster_params.smoothing_margins):...
                    (raster_params.time_after+raster_params.smoothing_margins)),1);
                
                
            end
        end
        
    case 'all'
        for f = 1:length(ind)
            ind_spk = ceil(data.trials(ind(f)).spike_times);
            ind_spk(ind_spk==0) = 1; % if spike is at time 0, move to 1.
            raster_t = zeros (data.trials(ind(f)).trial_length,1);
            raster_t(ind_spk) = 1;
            raster (:,f) = raster_t;
        end
 end


end

