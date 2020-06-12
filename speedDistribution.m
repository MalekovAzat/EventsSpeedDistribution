%The function calculate vector that contain speed distribution for sliding
%window.

function [speedDistrib] = speedDistribution(pixelMatrix, timeThreshold, intencityTrashold, windowSize)
    % speedDistrib = create3Dmatrix(512,512,8);

    if nargin < 2
        timeThreshold = 1;
        intencityTrashold = 0.7;
        windowSize = 8;
    end

    speedDistrib = [];

    sizeX = size(pixelMatrix, 1);
    sizeY = size(pixelMatrix, 2);
    
    for x = windowSize + 1: sizeX - windowSize
        for y = windowSize + 1: sizeY - windowSize
            inversedValue = filterValue(pixelMatrix(x,y));

            if (inversedValue > intencityTrashold)
                neighboringSpeed = neighboringSpeedDistrib(x, y, pixelMatrix, timeThreshold, intencityTrashold, windowSize);
                if neighboringSpeed ~= 0
                    speedDistrib = [speedDistrib, neighboringSpeed];
                end
            end
        end
    end
    % countMedAverDispes(speedDistrib);
end

function [averSpeed] = neighboringSpeedDistrib(x, y, pixelMatrix, timeThreshold, intencityTrashold, windowSize)
    tmpVectorsCount = 0;

    xOrd = 0;
    yOrd = 0;

    for shiftX = -windowSize: windowSize
        for shiftY = -windowSize: windowSize
            offsetX = x + shiftX;
            offsetY = y + shiftY;
            
            timeDifference = pixelMatrix(x, y) - pixelMatrix(offsetX, offsetY);
            inversedValue = filterValue(pixelMatrix(offsetX, offsetY));

            if (inversedValue > intencityTrashold) && (timeDifference > timeThreshold) && (offsetX ~= x || offsetY ~=y)
                tmpVectorsCount = tmpVectorsCount + 1;
                [theta, rho] = cart2pol(shiftX, shiftY);

                speed = rho / timeDifference;

                tempX = shiftX / rho * speed;
                tempY = shiftY / rho * speed;

                xOrd = xOrd + tempX;
                yOrd = yOrd + tempY;
            end
        end
    end

    [theta, rho] = cart2pol(xOrd, yOrd);
    averSpeed = rho./tmpVectorsCount;

    if isnan(averSpeed)
        averSpeed = 0;
    end
end

function [timeDist] = timeDiff(x1, y1, x2, y2, pixelMatrix)
    timeDist = abs(pixelMatrix(x1,y1) - pixelMatrix(x2,y2));
end

function [distrib] = countMedAverDispes(speedDistrib)

    med = median(speedDistrib);
    matExp = mean(speedDistrib);
    distrib = cov(speedDistrib);

    display(med);
    display(matExp);
    display(distrib);
end