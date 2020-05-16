% The function returns filled matrix 512x512x1500 with 1 or 0 values in
% each cell
function [resMtr] = fillMtr(mtr,data)

    sizeOfData = size(data,1);
    % 
    upd = textprogressbar(sizeOfData);
    % 
    resMtr = mtr;
    listOfIndexInData = 1:sizeOfData;
    for index = listOfIndexInData
        tmpData = cell2mat(data(index));
        resMtr = fillSectionOfMtr(tmpData, resMtr);
        % 
        upd(index);
        % 
    end
end

%The function sets cell in matrix to 1 if the event contain in array.
function [mtr] = fillSectionOfMtr(data,mtr)
    rowCount = size(data,1);
    for row = 1:rowCount
        x = data(row,1);
        y = data(row,2);
        z = data(row,3);
        
        mtr(x,y,z) = 1;
    end
end