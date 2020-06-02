% The function returns matrix that is used for calculate speed destribution
function[resultMatrix] = createTestMatrix(size, arrayOfTestValues)
    if nargin < 2 
        arrayOfTestValues = [2,1];
    end    

    resultMatrix = zeros(size, size);

    middleYValue = int8(size / 2);
    disp(middleYValue);
    for x = 1 : size
        for y = middleYValue : size
            resultMatrix(x,y) = arrayOfTestValues(y - middleYValue + 1);
        end
    end
end