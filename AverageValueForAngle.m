%The function returns angleList and speedList
% smoothingEventsMatrix - matrgix that had been calculated in main2.m
% time  - value forrm 0 to 1500
% timeDifferenceThreshold - value that is used for filtering by difference between neigbours pixels
% timeThreshold - value that is used for filtering by time value
% divisions -  units in a circle
% windowSize - the value contain size of sliding window that is used for speed calculations.
% 
function[angleList, averageSpeedList] = AverageValueForAngle(smoothingEventsMatrix, time, timeDifferenceThreshold, timeThreshold, windowSize)
    if (time == -1) 
        [sumMap, countsMap] = internalAverageValue(smoothingEventsMatrix, timeDifferenceThreshold, timeThreshold, windowSize);
    else
        [sumMap, countsMap] = internalAverageValue(smoothingEventsMatrix(:,:,time), timeDifferenceThreshold, timeThreshold, windowSize);
    end
    
    [angles, values] = convertData(sumMap, countsMap);
    angles = [angles,angles(1)];
    values = [values,values(1)];
    
    for i = 1: size(values,2)
        if isnan(values(i))
            values(i) = 0;
        end
    end
    
    polarplot(angles, values);
end

function [computedAngles] = formatAngle(angleList)
    computedAngles = zeros(1, size(angleList, 2) - 1);
    for index = 1: size(angleList, 2) - 1
        computedAngles(index) = (angleList(index) + angleList(index + 1)) / 2;
    end
end

%change range from [-pi,pi] to [0,pi]
function [angle] = rightRange(value)
    angle = value;
    if value < 0
        angle = value + 2 * pi;
    end
end

function [angle] = rightRange2(value)
    angle = value;
    if value > pi
        angle = value - 2 * pi;
    end
end

function [angles, values] = convertData(sumMap, countMap)
    angles = [];
    values = [];
    mapKey = keys(sumMap);
    
    for i = 1: size(mapKey,2)
        key = mapKey(i);
        key = key{1};
        angles = [angles, key];
        count = countMap(key);
        sum = sumMap(key);
        values = [values, sum/double(count)];
    end
end

function [mapAngleToSum, mapAngleToCount] = internalAverageValue(smoothingEventsMatrix, timeDifferenceThreshold, timeThreshold, windowSize)
    
    mapAngleToSum = containers.Map('KeyType','double', 'ValueType','double');
    mapAngleToCount = containers.Map('KeyType','double', 'ValueType','int8');

    
    matrixSizeX = size(smoothingEventsMatrix, 1);
    matrixSizeY = size(smoothingEventsMatrix, 2);
%   
    upd = textprogressbar((matrixSizeX  - windowSize)^2);
% 
    for x = windowSize + 1: matrixSizeX  - windowSize
        for y = windowSize + 1: matrixSizeY  - windowSize
            if (pointsInSet([x,y], smoothingEventsMatrix) && smoothingEventsMatrix(x, y) >= timeThreshold)
                [tmpMapAngleToSum, tmpMapAngleToCount] = neighboringSpeedDistrib(x, y, smoothingEventsMatrix, timeDifferenceThreshold, timeThreshold, windowSize);
                mapAngleToSum = addValuesToMap(mapAngleToSum, tmpMapAngleToSum);
                mapAngleToCount = addValuesToMap(mapAngleToCount, tmpMapAngleToCount);
            end
            upd(x*y) 
        end
    end
    
end


function [map] = addValuesToMap(map, tmpMap)
    tmpKeys = keys(tmpMap);
    for keyIndex = 1 : size(tmpKeys, 2)
        key = tmpKeys(keyIndex);
        key = key{1};
        if (isKey(map, key))
            map(key) = tmpMap(key) + map(key);
        else
            map(key) = tmpMap(key);
        end
    end
end

function [mapAngleToSum, mapAngleToCount] = neighboringSpeedDistrib(x, y, matrix, timeDifferenceThreshold, timeThreshold, windowSize)
    mapAngleToSum = containers.Map('KeyType','double', 'ValueType','double');
    mapAngleToCount = containers.Map('KeyType','double', 'ValueType','int8');
    
    for shiftX = -windowSize : windowSize
        for shiftY = -windowSize : windowSize
            offsetX = x + shiftX;
            offsetY = y + shiftY;
            
            [theta, rho] = cart2pol(shiftY, -shiftX);
            theta = rightRange(theta);
            if ~isKey(mapAngleToSum, theta)
                mapAngleToSum(theta) = 0;
                mapAngleToCount(theta) = 0;
            end
            if (pointsInSet([offsetX, offsetY], matrix) && (offsetX ~= x || offsetY ~= y) && matrix(offsetX, offsetY) >= timeThreshold) 
                currentDistance = euclidean_distance(x, y, offsetX, offsetY);
                currentTimeDifference = matrix(offsetX, offsetY) - matrix(x,y);

                if ((currentTimeDifference > 0) && (currentTimeDifference >  timeDifferenceThreshold) && currentDistance)
                    currentSpeed = currentDistance / currentTimeDifference;
                    
                    % determine the angle
                    
                    [theta, rho] = cart2pol(shiftY, -shiftX);
                    theta = rightRange(theta);
                        
%                     indexInArray = indexByAngle(theta, divisionsCount);
%                     sumArr(1, indexInArray) = sumArr(1, indexInArray) + currentSpeed;
%                     countsArr(1, indexInArray) = countsArr(1, indexInArray) + 1;
                    if isKey(mapAngleToSum, theta)
                        mapAngleToSum(theta) = mapAngleToSum(theta) + currentSpeed;
                        mapAngleToCount(theta) = mapAngleToCount(theta) + 1;
                    else
                        mapAngleToSum(theta) = currentSpeed;
                        mapAngleToCount(theta) = 1;
                    end
                end
            end
        end
    end
end
    
function [inPlurality] = pointsInSet(point, plurality) 
    x = point(1);
    y = point(2);
%     z = point(3);
    if (plurality(x, y) > 0)
        inPlurality = true;
        return;
    end
    inPlurality = false;
end

% The function returns