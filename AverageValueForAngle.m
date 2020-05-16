%The function returns angleList and speedList
% divisions - 
% windowSize - the size of
function[angleList, averageSpeedList] = AverageValueForAngle(smoothingEventsMatrix, time, timeThreshold, divisions, windowSize)
    if nargin == 3
        divisions = 6;
    end
    angleList = angleArray(divisions);
    
    [sumArr, countsArr] = internalAverageValue(smoothingEventsMatrix, time, timeThreshold, angleList, windowSize)
    angles = formatAngle(angleList)
    
    for index =  1:size(angles, 2)
         angles(index) = rightRange2(angles(index));
     end
    
    angles = [angles, angles(1)];
    rez = sumArr./countsArr;
    rez = [rez, rez(1)];
    polarplot(angles, rez);
    
end

% return array of value
% example if divisions = 6
% return [0    0.5236    1.0472    1.5708    2.0944    2.6180    3.1416]
function [anglesArray] = angleArray(divisions)
    stepAngle = pi * 2 / divisions;
    anglesArray = [];
    for current = 0: divisions
       newValue = current * stepAngle;
       anglesArray = [anglesArray, newValue];
    end
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

function [sumArr, countsArr] = internalAverageValue(smoothingEventsMatrix, timeIndex, timeThreshold, angleList, windowSize)
    
    divisionsCount = size(angleList, 2) - 1;
    sumArr = zeros(1, divisionsCount);
    countsArr = zeros(1, divisionsCount);
%     
    upd = textprogressbar((511 - windowSize)^2);  
% 
    for x = windowSize + 1: 511 - windowSize
        for y = windowSize + 1: 511 - windowSize
            if pointsInPlurality([x,y], smoothingEventsMatrix(:, :, timeIndex)) 
                [tmpSumArr, tmpCountArr] = neighboringSpeedDistrib(x, y, smoothingEventsMatrix(:, :, timeIndex), timeThreshold, divisionsCount, windowSize);
                sumArr = sumArr + tmpSumArr;
                countsArr = countsArr + tmpCountArr;
%             
                upd(x*y)
            end
        end
    end
    
end



function [sumArr, countsArr] = neighboringSpeedDistrib(x, y, matrix, timeThreshold, divisionsCount, windowSize)
    %In each value is contained sum of values that contain in [pi*index,
    %pi* (index + 1)
    sumArr = zeros(1, divisionsCount);
    %in each value
    countsArr = zeros(1, divisionsCount);
    
    for shiftX = -windowSize : windowSize
        for shiftY = -windowSize : windowSize
            offsetX = x + shiftX;
            offsetY = y + shiftY;
            
            if (pointsInPlurality([offsetX, offsetY], matrix) && (offsetX ~= x || offsetY ~= y))
                currentDistance = euclidean_distance(x, y, offsetX, offsetY);
                currentTimeDifference = matrix(offsetX, offsetY) - matrix(x,y);

                if (currentTimeDifference > 0 && currentDistance)
                    currentSpeed = currentDistance / currentTimeDifference;
                    
                    %determine the angle 
                    [theta, rho] = cart2pol(shiftX, shiftY);
                    theta = rightRange(theta);
                    
                    indexInArray = indexByAngle(theta, divisionsCount);
                    sumArr(1, indexInArray) = sumArr(1, indexInArray) + currentSpeed;
                    countsArr(1, indexInArray) = countsArr(1, indexInArray) + 1;
                end
            end
        end
    end
end
    
function [inPlurality] = pointsInPlurality(point, plurality) 
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
function [foundedIndex] = indexByAngle(theta, divisionsCount)
    angleArr = angleArray(divisionsCount);
    
    for index = 2 : size(angleArr, 2)
        if (angleArr(index - 1) <= theta) && (theta < angleArr(index))
            foundedIndex = index - 1;
            return;
        end
    end
end
