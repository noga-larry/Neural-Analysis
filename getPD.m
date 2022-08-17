function [PD,ind_PD,PD_exact] = getPD(data,ind,comparisonWindow,varargin)

directions = getDirections(data,ind);
[TC] = getTC(data, directions, ind, comparisonWindow, ...
    varargin{:});
[PD,ind_PD,PD_exact] = centerOfMass (TC, directions);