function [speedValues] = speedDistrubForAllTime(matrix)
    sizeT = size(matrix, 3);
    speedValues = NaN(1, 512*512*1500);
    for i = 1 : sizeT
        leftPos = (i-1) * 512 * 512 + 1;
        tmpVector = speedDistribution(matrix(:,:,i));
        rightPos = leftPos + size(tmpVector, 2) - 1;
        if rightPos > leftPos 
            speedValues(1, leftPos:rightPos) = tmpVector;
        end
        disp(i);
    end
end