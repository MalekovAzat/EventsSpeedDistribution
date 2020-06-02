%The function returns angleList and speedList
% smoothingEventsMatrix - matrgix that had been calculated in main2.m
% time  - value forrm 0 to 1500
% timeDifferenceThreshold - value that is used for filtering by difference between neigbours pixels
% timeThreshold - value that is used for filtering by time value
% divisions -  units in a circle
% windowSize - the value contain size of sliding window that is used for speed calculations.
% 
function[angleList, averageSpeedList] = AverageValueForAngle(smoothingEventsMatrix, time, timeDifferenceThreshold, timeThreshold, windowSize)
    [sumMap, counts, test] = internalAverageValue(smoothingEventsMatrix, timeDifferenceThreshold, timeThreshold, windowSize);

    [angles, values] = convertData(sumMap, counts);
    angles = [angles,angles(1)];
    values = [values,values(1)];
    
    for i = 1: size(values,2)
        if isnan(values(i))
            values(i) = 0;
        end
    end
    h1  = figure('Name', sprintf('time %f', time));
    polarplot(angles, values);
    
    handle = implay(test);
    set(handle.Parent, 'Name', sprintf('time %f', time))
    cmap = jet(256);
    handle.Visual.ColorMap.Map = cmap;
    handle.Visual.ColorMap.UserRangeMin = 0;
    handle.Visual.ColorMap.UserRangeMax = 1;
    handle.Visual.ColorMap.UserRange = 1;
    handle.Visual.ColorMap.MapExpression = 'jet';
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

function [angles, values] = convertData(sumMap, count)
    angles = [];
    values = [];
    mapKey = keys(sumMap);
    
    for i = 1: size(mapKey,2)
        key = mapKey(i);
        key = key{1};
        angles = [angles, key];
        
        sum = sumMap(key);
        values = [values, sum/double(count)];
    end
end

function [mapAngleToSum, count, testMatrix] = internalAverageValue(smoothingEventsMatrix,timeDifferenceThreshold, timeThreshold, windowSize)
    
    mapAngleToSum = containers.Map('KeyType','double', 'ValueType','double');
    count = 0;

    matrixSizeX = size(smoothingEventsMatrix, 1);
    matrixSizeY = size(smoothingEventsMatrix, 2);
    testMatrix = zeros(matrixSizeX, matrixSizeY);
%   
    upd = textprogressbar((matrixSizeX  - windowSize)^2);
% 
    for x = windowSize + 1: matrixSizeX  - windowSize
        for y = windowSize + 1: matrixSizeY  - windowSize
            invValue = filterValue(smoothingEventsMatrix(x, y));
            if (pointsInSet([x,y], smoothingEventsMatrix) && invValue >= timeThreshold)
                testMatrix(x, y) = invValue;
                [tmpMapAngleToSum, tmpCount] = neighboringSpeedDistrib(x, y, smoothingEventsMatrix,timeDifferenceThreshold, timeThreshold, windowSize);
                mapAngleToSum = addValuesToMap(mapAngleToSum, tmpMapAngleToSum);
                count = tmpCount + count;
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

function [mapAngleToSum, count] = neighboringSpeedDistrib(x, y, matrix, timeDifferenceThreshold, timeThreshold, windowSize)
    mapAngleToSum = containers.Map('KeyType','double', 'ValueType','double');
    count = 0;
    
    for shiftX = -windowSize : windowSize
        for shiftY = -windowSize : windowSize
            offsetX = x + shiftX;
            offsetY = y + shiftY;
            
            [theta, rho] = cart2pol(shiftY, -shiftX);
            theta = rightRange(theta);
            
            if ~isKey(mapAngleToSum, theta)
                mapAngleToSum(theta) = 0;
            end
            
            invValue = filterValue(matrix(offsetX, offsetY));

            if (pointsInSet([offsetX, offsetY], matrix) && (offsetX ~= x || offsetY ~= y) && invValue >= timeThreshold) 
                currentDistance = euclidean_distance(x, y, offsetX, offsetY);
                
                currentTimeDifference = matrix(x,y) - matrix(offsetX, offsetY);

                if ((currentTimeDifference > 0) && (currentTimeDifference >  timeDifferenceThreshold) && currentDistance)
                    
                    currentSpeed = currentDistance / currentTimeDifference;
                    [theta, rho] = cart2pol(shiftY, -shiftX);
                    theta = rightRange(theta);

                    if isKey(mapAngleToSum, theta)
                        mapAngleToSum(theta) = mapAngleToSum(theta) + currentSpeed;
                    else
                        mapAngleToSum(theta) = currentSpeed;
                    end
                    count = count + 1;
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


function [filterValue] = filterValue(val)
    if val ~= 0 
        filterValue = 1/val;
    else
        filterValue = 0;
    end

end