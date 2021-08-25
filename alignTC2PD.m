function alignedTC = alignTC2PD(TC,directions)

newPDInd = ceil(length(directions)/2);
[~,ind_PD] = centerOfMass (TC, directions);
tmp = circshift(TC,-ind_PD+newPDInd);

% Add null direction to the begining
alignedTC = [tmp(end); tmp];