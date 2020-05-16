%The function calculate vector that contain speed distribution for sliding
%window.

function [speedDistrib] = speedDistribution(pixelMatrix, timeIndex, timeThreshold)
    % speedDistrib = create3Dmatrix(512,512,8);
    speedDistrib = [];
    upd = textprogressbar(512*512);

    for x  = 2:511
        for y = 2:511
            neighboringSpeed = neighboringSpeedDistrib(x, y, pixelMatrix(:, :, timeIndex), timeThreshold);
            speedDistrib = [speedDistrib, neighboringSpeed];
            upd((x+1)*(y+1));
        end
    end
    countMedAverDispes(speedDistrib);
end

function [speedDistribArr] = neighboringSpeedDistrib(x, y, pixelMatrix, timeThreshold)
    speedDistribArr = [];
    for xOffset = -1:1
        for yOffset = -1:1
            distance = euclidean_distance(x, y, x + xOffset, y + yOffset);
            timeDifference = timeDiff(x, y, x+xOffset, y+yOffset, pixelMatrix);
            if distance ~= 0 & pixelMatrix(x,y) <= 3
                if timeDifference > timeThreshold
                    addSpeed = distance / timeDifference;
                    speedDistribArr = [speedDistribArr, addSpeed];
                end
            end
        end
    end
end

function [timeDist] = timeDiff(x1, y1, x2, y2, pixelMatrix)
    timeDist = abs(pixelMatrix(x1,y1) - pixelMatrix(x2,y2));
end

function [distrib] = countMedAverDispes(speedDistrib)
    len = length(speedDistrib);
    speedDistrib = sort(speedDistrib);
    newValues = [];

    med = median(speedDistrib);
    matExp = mean(speedDistrib);
    distrib = cov(speedDistrib);

    display(med);
    display(matExp);
    display(distrib);
end