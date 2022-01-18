function [PD,ind_PD] = getPD(data,ind,comparisonWindow,varargin)

directions = getDirections(data,ind);
[TC] = getTC(data, directions, ind, comparisonWindow, ...
    varargin{:});
[PD,ind_PD] = centerOfMass (TC, directions);