function[psth] = raster2psth(raster,params) 

% This function takes rasters and trasforms them in to smoothed psths. 
% Input:    raster      A matrix whos first dimnsion is time and second
%                       dimension is trials number.
%           params      Structure with parameters for PSTH.
%             .SD       Standard deviation for Gaussian smoothing.
%             .smoothing_margins
%                       Margins to avoid edge effects
% Output:   psth        an array of average smoothed firing rate in time,
%                       will be shorters then raster as edges are removed 
%                       to avoid edge artifacts. 

psth = nanmean(raster',1);
win = normpdf(-3*params.SD:3*params.SD,0,params.SD);
win = win/sum(win);
psth = filtfilt(win,1,psth);
psth = psth*1000;
psth = psth((params.smoothing_margins+1):(length(psth)-params.smoothing_margins));

  
end

