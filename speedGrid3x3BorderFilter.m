% deprecated code
% arg: eventsMatrix - 512x512  
%      borderMatrix - 512X512 
%      spointsMatrix - 512x512 
% return: array with speedDistrArray

function [speedDistrArray] = speedGrid3x3BorderFilter(borderMatrix, spointMatrix, currentTime)
    speedDistrArray = [];
    for x = 2:511
        for y = 2:511
            point = [x,y,currentTime];
            % if the point contain in borders or points - > calculate 
            if (pointsInPlurality(point, borderMatrix) || pointsInPlurality(point, spointMatrix))
                speedDistrArray = [speedDistrArray, cell3x3AngularVectors(point, borderMatrix, spointMatrix)];
            end
        end
    end
end

% return true if cell (x,y,z) more that 0
function [inPlurality] = pointsInPlurality(point, plurality) 
    x = point(1);
    y = point(2);
    z = point(3);
    if (plurality(x, y, z) > 0)
        inPlurality = true;
        return;
    end
    inPlurality = false;
end

function [maxSpeedAngleValue] = cell3x3AngularVectors(point, borderMatrix, spointMatrix)
    currentX = point(1);
    currentY = point(2);
    currentZ = point(3);
    
    maxSpeedValue = 0;
    maxSpeedAngleValue = 0;
    
    for x = -1:1
        for y = -1:1
            offsetPoint = [currentX + x, currentY + y, currentZ];
            if ((pointsInPlurality(point, borderMatrix) || pointsInPlurality(point, spointMatrix)) && (pointsInPlurality(offsetPoint, borderMatrix) || pointsInPlurality(offsetPoint, spointMatrix)) && x~=0 && y~=0)
                currentDistance = euclidean_distance(currentX, currentY,currentX + x, currentY + y);
                
                currentTimeDifference  = -1 * (spointMatrix(currentX, currentY, currentZ) - spointMatrix(currentX + x, currentY + y, currentZ));

                if (currentTimeDifference > 0 && currentDistance) 
                    currentSpeed = currentDistance / currentTimeDifference;
                    if (currentSpeed > maxSpeedValue)
                        maxSpeedValue = currentSpeed;
                        maxSpeedAngleValue = angleByOffset(x,y);
                    end
                end
            end
        end 
    end
end

% Return the angle by offset
function [angle] = angleByOffset(x,y)
    if (x > 0 && y >=0 )
        angle = atan(y/x);
    elseif (x > 0 && y < 0)
        angle = atan(y/x) + 2*pi;
    elseif (x < 0)
        angle = atan(y/x) + pi;
    elseif (x == 0 && y > 0)
        angle = pi/2;
    elseif (x == 0 && y < 0)
        angle = 3/2 * pi;
    end
end