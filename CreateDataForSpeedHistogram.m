function [values, angles] = CreateDataForSpeedHistogram(speedMatrix, anglesMatrix, bins)
    anglesForBin = anglesByBin(bins);

    sizeX = size(speedMatrix, 1);
    sizeY = size(speedMatrix, 2);
    
    speedSumArray = zeros(1,bins);
    vectorsCount = 0;

    for x = 1: sizeX
        for y = 1:sizeY
            if (anglesMatrix (x,y) ~= 2*pi)
                index = idexByAngle(anglesMatrix(x, y), anglesForBin);
                speedSumArray(index) = speedSumArray(index) + speedMatrix(x, y);
                vectorsCount = vectorsCount + 1;
            end
        end
    end

    % [values, angles] = convertValuesForHist(speedSumArray, anglesForBin);
    values = speedSumArray;
    angles = anglesForBin;
    values = [values, values(1)];
%     angles = [angles(:), angles(1)];
    angles(size(angles,2) - 1) = angles(1);

% use it if you want to ger a rose    
%     [values, angles] = convertValuesForHist(speedSumArray, anglesForBin);
%     values = speedSumArray;
%     angles = anglesForBin;
%     values = [values, values(1)];
%     angles = [angles(:), angles(1)];
end

function [angles] = anglesByBin(bin)
    angles = linspace(0, 2*pi, bin + 1);
end

function [index] = idexByAngle(angle, angelsArray)
%     disp( rad2deg(angelsArray));
    anglesArraySize = size(angelsArray, 2) - 1;
    shift = 2 * pi / (2 * anglesArraySize);
    for i = 1 : anglesArraySize + 1

        rightAngleValue = angelsArray(i) - shift;
        leftAngleValue = angelsArray(i) + shift;
        
        if (rightAngleValue <= angle) && (angle < leftAngleValue)
            index = i;
            if index == anglesArraySize + 1
                index = 1;
            end
        end
    end
end

function [values,angles] = convertValuesForHist(speedSumArray, anglesArray, betweenPointsCount)
    if nargin < 3
        betweenPointsCount = 100;
    end
    anglesArraySize = size(anglesArray, 2) - 1;
    shift = 2 * pi / (2 * anglesArraySize);
    values = [];
    angles = [];
    
    for i = 1: anglesArraySize 
        rightAngleValue = anglesArray(i) - shift;
        leftAngleValue = anglesArray(i) + shift;
        
        anglesInGap = linspace(rightAngleValue, leftAngleValue, betweenPointsCount);
        
        tmpValues = zeros(1, betweenPointsCount);
        tmpValues = tmpValues + speedSumArray(i);
        
        angles = [angles, anglesInGap];
        values = [values, tmpValues];
    end
end