% The function shows dataMtr (size 2 matrix) as image 
% The values in matrix are form 0 to 1
function [] = showImage(dataMtr, name)
    
    if nargin < 2
        name = "";
    end
    
    imagesc(dataMtr);
    limits = [];
    limits(1) = double(min(dataMtr(:)));
    limits(2) = double(max(dataMtr(:)));
    handle = implay(dataMtr);
    cmap = jet(256);
    handle.Visual.ColorMap.Map = cmap;
    handle.Visual.ColorMap.UserRangeMin = limits(1);
    handle.Visual.ColorMap.UserRangeMax = 1;
    handle.Visual.ColorMap.UserRange = 1;
    handle.Visual.ColorMap.MapExpression = 'jet';
    
    if (name ~= "") 
        imwrite(im2uint8(dataMtr), jet(256), name);
    end
end
