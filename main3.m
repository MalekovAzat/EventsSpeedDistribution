% The function calculate speed destribution and shows wind rose for time
% moment 

function [] = main3(dataPath, matrixName, calculatePath, timeMoment, timeThreshold)
    if nargin < 5
        dataPath = "data";
        matrixName = "smooth_colorEvents3.mat"
        baseLinePath = "data";
        calculatePath = "Calculate";
        timeMoment = 0;
        timeThreshold = 0.1;
    end
    
%     data = matfile(dataPath + "/events_3d.mat");
    % matrix from main2.m
    smothingEventsMatrix = matfile(dataPath + "/" + matrixName).dataMtr;

    speedDistribResult = speedDistribution(smothingEventsMatrix, timeMoment, timeThreshold);
    
    save(calculatePath + "/speedDestribution.mat", "speedDistribResult", "-v7.3");
end