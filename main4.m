function [] = main4(dataPath, matrixName, calculatePath, timeMoment, timeThreshold, windowSize)
    if nargin < 5
        dataPath = "data";
        matrixName = "smooth_colorEvents3.mat"
        baseLinePath = "data";
        calculatePath = "Calculate";
        timeMoment = 0;
        timeThreshold = 0.1;
        windowSize = 3;
    end
    
    smothingEventsMatrix = matfile(dataPath + "/" + matrixName).dataMtr;
    
    
end