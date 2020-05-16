% play video for mtr
function [] = showEventsMatrix(dataMtr)
    % cmap = jet(256);
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
end