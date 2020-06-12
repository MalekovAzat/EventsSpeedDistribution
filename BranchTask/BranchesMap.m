function [branchMap] = BranchesMap(folderName)
    fileNamesArray = getFileNamesFromFolder(folderName);
    branchMap = readBranchesRoots(fileNamesArray, folderName);
end

function [fileNameArray] = getFileNamesFromFolder(folderName, filter)
    if nargin < 2
        filter = ".txt";
    end
    fileNameArray = [];
    listing = dir(folderName);
    for index  = 1: size(listing, 1)
        fileName = listing(index).name;
        if size(strfind(fileName, filter), 2) > 0
            fileNameArray = [fileNameArray, string(fileName)];
        end
    end
    fileNameArray = fileNameArray.';
end