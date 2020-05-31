% The function returns matrix that is used for calculate speed destribution
function[resultMatrix] = createTestMatrix(size, arrayOfTestValues)
    if nargin < 2 
        arrayOfTestValues = [0.5, 0.6, 0.7, 0.8, 0.911];
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