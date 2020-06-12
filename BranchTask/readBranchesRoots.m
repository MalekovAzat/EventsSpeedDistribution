%The function reads text file and return the map with root points for each
%branch
function [map] = readBranchesRoots(textFileNameArray, folder)
    if nargin < 2
       folder = ""; 
    end
    branchesCount = size(textFileNameArray, 1);
    map = containers.Map('keyType', 'int32', 'valueType', 'any');
    for fileIndex = 1 : branchesCount
        mapKey = split(textFileNameArray(fileIndex),["_", "."]);
        mapKey = int32(str2num(mapKey(2)));
        
        map(mapKey) = readDataFromFile(textFileNameArray(fileIndex), folder);
    end
end

function[data] = readDataFromFile(filename, folder)
    fileID = fopen(folder + "/" + filename, 'r');
    sizeData = [2 inf];
    data = fscanf(fileID, '%f %f', sizeData);
    data = int16(data.');
end