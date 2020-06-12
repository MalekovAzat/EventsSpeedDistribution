% The function returns vector that contain angles for rose
function [vectorForAngle] = FilterForRozeByAngle(anglesMatrix)
    sizeX = size(anglesMatrix, 1);
    sizeY = size(anglesMatrix, 2);
    vectorForAngle = [];
    for x = 1: sizeX
        for y = 1:sizeY
            if (anglesMatrix(x,y) < 2*pi) && (anglesMatrix(x,y) > 0)
                currentIndex = size(vectorForAngle, 2) + 1;
                vectorForAngle(currentIndex) = double(anglesMatrix(x,y));
            end
        end
    end
end