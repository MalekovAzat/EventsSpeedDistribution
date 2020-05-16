% The function reads data from data/points.mat and create 3 files:
% - eventsMatrix.mat - contain restructed data from data/points.mat, it is
% matrix 512x512x1500 with information about events.
% - countedEventsMatrix - contain the live time for each pixel in each moment, it
% is matrix 512x512x1500.
% - invertedEventsMatrix.mat -contain the reversed value for each pixel in
% each moment (without any trashhold and filters).
function [dataMatrix_1] = main(dataPath, calculationsPath)
%     fileName = "data/points.mat";
    data = matfile(dataPath);
    data = data.points;
    
    dataMatrix = zeros(sizeX,sizeY,sizeZ);
    
    dataMatrix = fillingDataMtr(data, dataMatrix);
    save(calculationsPath + "/eventsMatrix.mat", "dataMatrix", "-v7.3");
    
    dataMatrix_1 = countEventsMtr(dataMatrix);
    save(calculationsPath + "/countedEventsMatrix.mat", "dataMatrix_1","-v7.3");
    
    dataMatrix_1 = reverseEvents(dataMatrix_1);
    save(calculationsPath + "/invertedEventsMatrix.mat", "dataMatrix_1","-v7.3");
end

function [dataMatrix] = fillingDataMtr(data , dataMatrix)
    % The value contain count of cells in data object
    cellCount = size(data,1);
    
    for currentIndex  = 1:cellCount
        % Get the data from current cell
        tmpData = (data(currentIndex));
        dataMatrix = fillMtr(tmpData, dataMatrix);
    end
end

%The function sets cell in matrix to 1 if the event contain in array.
function [mtr] = fillMtr(arr, mtr)
    %Get count of points in current cell
    pointsCount = size(arr,1);
    for currIndex = 1:pointsCount
        timeIndex = arr(currIndex,3);
        x = arr(currIndex,1);
        y = arr(currIndex,2);
        mtr(x , y, timeIndex) = 1;
    end
end

% The function calculate live time for each pixel by previous value
function [newMtr] = countEventsMtr(mtrSimple)
    numOfZRows = size(mtrSimple,3);
    countX = size(mtrSimple,1);
    countY = size(mtrSimple,2);
    
    newMtr = mtrSimple;
    
    for time = 2:numOfZRows
        for x = 1:countX
            for y = 1:countY
                if(newMtr(x,y,time) == 1 )
                    newMtr(x,y,time) = newMtr(x,y, time-1) + 1;
                end
% stupid code                 
%                 elseif(newMtr(x,y,time) == 0)
%                     newMtr(x,y,time) = 0;
%                 end
            end
        end
    end
%     myCell = squeeze(num2cell(newMtr,[1 2]));
end

% The function changes value from X to 1/X for each pixel in each time 
% (without any trashold and smooth)
function [mtr] = reverseEvents(mtr)
    countT = size(mtrSimple,3);
    countX = size(mtrSimple,1);
    countY = size(mtrSimple,2);
    
    for t = 1:countT
        for x = 1:countX
            for y= 1:countY
                if (mtr(x,y,t) ~= 0)
                    mtr(x,y,t) = 1/mtr(x,y,t);
                end
            end
        end
    end
end