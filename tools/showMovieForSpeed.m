function [] = showMovieForSpeed(dataMtr)
    % cmap = jet(256);
    limits = [];
    limits(1) = double(min(dataMtr(:)));
    limits(2) = double(max(dataMtr(:)));
    handle = implay(dataMtr);
    cmap = jet(256);
    handle.Visual.ColorMap.Map = cmap;
    handle.Visual.ColorMap.UserRangeMin = limits(1);
    handle.Visual.ColorMap.UserRangeMax = limits(2);
    handle.Visual.ColorMap.UserRange = 1;
    handle.Visual.ColorMap.MapExpression = 'jet';
    handle.Parent.Position = [100 100 700 550];
end