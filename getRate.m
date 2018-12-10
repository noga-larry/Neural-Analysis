function aveRate = getRate (data, ind)
% This function calcalates the firing rate of the cell in all or a subset
% of trials in data.
% Inputs:    data      A data structure contatining the cell's data
%            ind       Optional, the indices of trials that are relevet. If
%                      ind is not given th function will calculate the ratr
%                      over all trials. 
% Outputs:   aveRate   The average firing rate of the cell.  

if ~exist('ind','var')
	ind = 1:length(data.trials);
end
rate = nan(length(ind),1);
for ii=1:length(ind)
    rate(ii) = (length(data.trials(ind(ii)).spike_times)...
        /data.trials(ind(ii)).trial_length)*1000;
end

aveRate = mean(rate);