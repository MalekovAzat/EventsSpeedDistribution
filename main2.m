% The function calculate eventsMatrir without noizes (threshold is used for each pixel in each moment of time)
% Second version of main.m

function [dataMtr] = main2(dataPath, baseLinePath, calculatePath)
    
    if nargin < 3
        dataPath = "data";
        baseLinePath = "data";
        calculatePath = "calculate";
    end

    % "data/points.mat"
    data = matfile(dataPath + "/points.mat");
    % "data/df_baseline_video.mat"
    intensityData = matfile(baseLinePath + "/df_baseline_video.mat");
    
    points = data.points;
    
    intensityData = intensityData.df_baseline_video;
    
    dataMtr = zeros(512,512,1500);
    dataMtr = fillMtr(dataMtr, points);
    
    noiseMtr = matfile(dataPath + "/f_noise_sigma.mat");
    noiseMtr = noiseMtr.f_noise_sigma;
    
    
%     cutOffNoiseMtr = cutOffNoise(dataMtr, noiseMtr, intensityData);
%     save(calculatePath + "cutOffNoseMtr.mat", "cutOffNoseMtr", "-v7.3");

    % ___________ |||||| ___________
    
    dataMtr = smothingEventsMatrix(dataMtr, noiseMtr, intensityData);
    dataMtr = reverseEvents(dataMtr);
%     save caclulated Matrix
    save(calculatePath + "/smoothingColorEvents.mat", "dataMtr", "-v7.3");

    % timeMoment = 120;
    % timeThreshold = 0.01;
    

    % speedDistribResult = speedDistribution(dataMtr, timeMoment, 0.01);

    % save(pathPrefix+"speedDistribVector.mat", "speedDistribResult", "-v7.3");

    % showEventsMatrix(dataMtr);
end