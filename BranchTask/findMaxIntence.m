function [maxIntMtr]  = findMaxIntence(intenceMatrix)

    sizeX = size(intenceMatrix, 1);
    sizeY = size(intenceMatrix, 2);
    maxIntMtr = zeros(sizeX, sizeY);
    for x = 1: sizeX
        for y = 1 : sizeY
            maxIntMtr(x, y) = max(intenceMatrix(x,y,:));
        end
    end
end
