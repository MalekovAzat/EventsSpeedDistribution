% The function calculate events matrix with smoothing
%input:
% eventsMtr - 0 or 1 in each cell
% noiseMtr - trashhold value for each pixel
% intensMtr - intencity for each pixel in each time moment

function [resMtr]  = smothingEventsMatrix(eventsMtr, noiseMtr, intensMtr)
    xIndexCount = size(eventsMtr,1);
    yIndexCount = size(eventsMtr,2);
    zIndexCount = size(eventsMtr,3);
    % 
        upd = textprogressbar(zIndexCount);
    % 
    for z = 2:zIndexCount
        for x = 1:xIndexCount
            for y = 1:yIndexCount
                if(eventsMtr(x,y,z) == 1)
                    if(intensMtr(x,y,z) > noiseMtr(x,y) ) && (intensMtr(x,y,z - 1) > noiseMtr(x,y))
                        eventsMtr(x,y,z) = eventsMtr(x,y,z - 1) + 1;
                    elseif (intensMtr(x,y,z) > noiseMtr(x,y)) && (intensMtr(x,y,z - 1) <= noiseMtr(x,y))
                        leftBorder = intensMtr(x,y,z - 1);
                        rightBorder = intensMtr(x,y,z);
                        noiseLine = noiseMtr(x,y);
%                         eventsMtr(x,y,z) = eventsMtr(x,y,z - 1) + getSmoothValue(leftBorder, rightBorder, noiseLine);
                        eventsMtr(x,y,z) = getSmoothValue(leftBorder, rightBorder, noiseLine);
                    else
                        eventsMtr(x,y,z) = 0;
                    end
                end
            end
        end
        %
        upd(z);
        %
    end
    resMtr = eventsMtr;
end

function [val] = getSmoothValue(leftBorder,rightBorder, noiseLine)
    aMtr = [0,1;1,1];
    bVect = [leftBorder;rightBorder];
    x = aMtr\ bVect;
    coefA = x(1);
    coefB = x(2);
    xForNoiseValue = (noiseLine - coefB)/coefA;
    val = 1 - xForNoiseValue;
end