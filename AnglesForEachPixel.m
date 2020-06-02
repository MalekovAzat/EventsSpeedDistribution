%The function returnns matrixn with 512*512 size that contain angle speed-vectors in each pixel

function[angleMatrix, speedMatrix] = AnglesForEachPixel(smoothingEventsMatrix, revSmoothingEventsMatrix, time, timeDifferenceThreshold, timeThreshold, windowSize)
    sizeX = size(smoothingEventsMatrix, 1);
    sizeY = size(smoothingEventsMatrix, 2);
    angleMatrix = zeros(sizeX, sizeY);
    speedMatrix = zeros(sizeX, sizeY);
    
    for x = 1 : sizeX
        for y = 1 : sizeY
            if (x < windowSize + 1 || y < windowSize + 1) || (x > sizeX - windowSize || y > sizeY - windowSize  )
                angleMatrix(x,y) = 2 * pi;
            end
        end
    end
    
    
    for x = windowSize + 1: sizeX - windowSize
        for y = windowSize + 1: sizeY - windowSize
            inversedValue = filterValue(smoothingEventsMatrix (x,y));
            
            if (inversedValue > timeThreshold)
                [tmpAngleMatrix, tmpSpeedMatrix] = collectAngles(x, y, smoothingEventsMatrix, timeDifferenceThreshold, timeThreshold, windowSize);
                angleMatrix = angleMatrix + tmpAngleMatrix;
                speedMatrix = speedMatrix + tmpSpeedMatrix;
            else
                angleMatrix(x, y) = 2 * pi;
            end
        end
    end
end

%the function returns temporary matrix for AnglesForEachPixel function
function [tmpAngleMatrix, tmpSpeedMatrix] = collectAngles(x, y, matrix, timeDifferenceThreshold, timeThreshold, windowSize)
    
    sizeX = size(matrix, 1);
    sizeY = size(matrix, 2);
    tmpAngleMatrix = zeros(sizeX, sizeY);
    tmpSpeedMatrix = zeros(sizeX, sizeY);

    xOrd = 0;
    yOrd = 0;

    tmpVectorsCount = 0;

    for shiftX = -windowSize: windowSize
        for shiftY = -windowSize: windowSize
            offsetX = x + shiftX;
            offsetY = y + shiftY;
            %value is 
            inversedValue = filterValue(matrix(offsetX, offsetY));
            if (abs(shiftX) == windowSize) || (abs(shiftY) == windowSize) && (inversedValue >= timeThreshold)
                currentTimeDifference = matrix(x,y) - matrix(offsetX, offsetY);
                if (currentTimeDifference > timeDifferenceThreshold)
                    %take angle and distance
                    tmpVectorsCount = tmpVectorsCount + 1;
                    [theta, rho] = cart2pol(shiftY, -shiftX);
                    speed = rho / currentTimeDifference;
                    %coord for speed-vector;
                    tempX = shiftY/rho * speed;
                    tempY = -shiftX/rho * speed;
                    % collect them to common vector
                    xOrd = xOrd + tempX;
                    yOrd = yOrd + tempY;
                end
            end
        end
    end

    %determine the angle
    [theta, rho] = cart2pol(xOrd, yOrd);

    if rho ~= 0
        tmpSpeedMatrix(x,y) = rho / tmpVectorsCount;
    else
        tmpSpeedMatrix(x,y) = 0;
    end
    
    if (xOrd == 0 && yOrd == 0)
        tmpAngleMatrix(x,y) = 2 * pi;
    else
        theta = rightRange(theta);
        tmpAngleMatrix(x,y) = theta;
    end
end

function [angle] = rightRange(value)
    angle = value;
    if value < 0
        angle = value + 2 * pi;
    end
end