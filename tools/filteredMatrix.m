%The function returns the matrix with values those more then threshold value.
function [resultMatrix] = filteredMatrix(matrix, treshHold)
    sizeX = size(matrix, 1);
    sizeY = size(matrix, 2);
    resultMatrix = zeros(sizeX, sizeY);
    resultMatrix = matrix;
    
    for x = 1:sizeX
        for y = 1:sizeY
            if resultMatrix(x,y) < treshHold
                resultMatrix(x,y) = 0;
            end
        end
    end
end