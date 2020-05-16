
% 1 - если это граница
% 0 - иначе
% arg events_3d(1, 1).border
function [resultMatrix] = bordersMatrix (borders) 
    
    resultMatrix = create3Dmatrix(512, 512, 1500);
    for index = 1:length(borders)
        currentCell = borders(index);
        resultMatrix = fillMatrix(resultMatrix, currentCell);
    end
end

% заполнение матрицы границ
function [matrix] = fillMatrix(matrix, cell)
    % for line = 1:length(cell{1, 1})
    for line = 1 : length(cell{1, 1})
        x = cell{1,1}(line, 1);
        y = cell{1,1}(line, 2);
        t = cell{1,1}(line, 3);
        
        matrix(x,y,t) = 1;
    end
end