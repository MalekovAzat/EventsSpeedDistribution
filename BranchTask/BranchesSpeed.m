% The fuction uses the window for count the speed in direction
% and returns the map for each branch
function [speedMap] = BranchesSpeed(smootchingEventsMatrix, branchesMap, windowSize, branchIndex)
    if nargin < 3
        windowSize = 8;
        branchIndex = -1;
    end
    speedMap = containers.Map('keyType', 'int32', 'valueType', 'any');
    if (branchIndex == -1)
    keysBranchesArray = keys(branchesMap);
    for keyIndex  = 1:size(keysBranchesArray, 2)
        internalKey = keysBranchesArray(keyIndex);
        internalKey = internalKey{1};
        speedMap(internalKey) = averageSpeedForBranch(branchesMap(internalKey), smootchingEventsMatrix, windowSize);
    end
    else
        speedMap(branchIndex) = averageSpeedForBranch(branchesMap(branchIndex), smootchingEventsMatrix, windowSize);
    end
end

function [branchInfo] = averageSpeedForBranch(pointsArray, matrix, windowSize)
    %  At firs you need the direction(angle)
    pointsCount = size(pointsArray, 1);

    revPointsArray = flip(pointsArray);
    %The matrix contain speed for each pixel in branch
    speedMatrix = zeros(size(matrix, 1), size(matrix, 2));
    revSpeedMatrix = zeros(size(matrix, 1), size(matrix, 2));
    coordForEachPixel = [];
    speedForEachPixel = [];
    revSpeedForEachPixel = [];
    
    branchMatrix = zeros(size(matrix, 1), size(matrix, 2));

    if pointsCount < 2
        branchInfo = struct;
        branchInfo.lenArray = [];
        branchInfo.speedArray = [];
        branchInfo.direction = NaN;
        branchInfo.speedMatrix = [];
        return;
    end

    % direction =  getDirectionByExtremePoints(pointsArray(1,:), pointsArray(pointsCount, :));
    % revDirection = getDirectionByExtremePoints(revPointsArray(1, :), revPointsArray(pointsCount, :));
    
    % for ech pixel in branch count speed
    for pixelIndex = 1 : pointsCount - 1
        coordForEachPixel(pixelIndex) = pixelIndex;
        x = pointsArray(pixelIndex, 1);
        y = pointsArray(pixelIndex, 2);
        branchMatrix(x, y) = 1;
        [speedForEachPixel(pixelIndex), tmpSpeedMatrix] = neighboringSpeedByDirection(pointsArray(pixelIndex, :), pointsArray(end, :), matrix, windowSize);
        speedMatrix = speedMatrix + tmpSpeedMatrix;
    end
    
    branchInfo = struct;
    branchInfo.lenArray = coordForEachPixel;
    branchInfo.speedArray = speedForEachPixel;
    branchInfo.speedMatrix = speedMatrix;
    branchInfo.branchMatrix = branchMatrix;
    
end

function [projection, tmpSpeedMatrix] = neighboringSpeedByDirection(currentPoint, endPoint, matrix, windowSize, timeDiffTrashhold, brightnessTreshold);
    if nargin < 5
        timeDiffTrashhold = 1;
        brightnessTreshold = 0.7;   
    end

    directionVector  = endPoint - currentPoint;
        
    resultVector = zeros(1, 2);
    tmpVectorsCount = 0;
    x = currentPoint(1);
    y = currentPoint(2);
    
    tmpSpeedMatrix = zeros(size(matrix, 1), size(matrix, 2));

    for shiftX = -windowSize : windowSize
        for shiftY = -windowSize : windowSize
            offsetX = x + shiftX;
            offsetY = y + shiftY;

            currIntencity = filterValue(matrix(offsetX, offsetY));

            timeDifference  = matrix(x, y) - matrix(offsetX, offsetY);
                        
            if (offsetX ~= x || offsetY ~= y) && (currIntencity > brightnessTreshold) && (timeDifference > timeDiffTrashhold)
                tmpVectorsCount = tmpVectorsCount + 1;
                
                resultVector(1) = resultVector(1) + shiftX / timeDifference;
                resultVector(2) = resultVector(2) + shiftY / timeDifference;
            end
        end
    end
    
    resultVector = resultVector./tmpVectorsCount;
    %find a projection 

%     aVec = double([directionVector(1), directionVector(2), 0]);
%     bVec = [resultVector(1), resultVector(2), 0];
%     angleBtv = abs( atan2(norm(cross(aVec, bVec)), dot(aVec, bVec)));
    `
    
%     if (angleBtv <= pi/4)
    projection = dot(double(directionVector),   ) / sqrt(sum(directionVector.*directionVector));
    if isnan(projection)
        projection = 0;
    end`
%     else
%         projection = 0;
%     end
    if projection > 0
        fprintf("%.02f %.02f - %.15f\n", [resultVector(1), resultVector(2), projection]);
    end
    tmpSpeedMatrix(x, y) = projection;
end