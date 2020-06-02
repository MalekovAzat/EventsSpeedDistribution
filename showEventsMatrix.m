% play video for mtr
function [] = showEventsMatrix(dataMtr)
    % cmap = jet(256);
    limits = [];
    limits(1) = double(min(dataMtr(:)));
    limits(2) = double(max(dataMtr(:)));
    handle = implay(dataMtr);
    hmap(1:360,1) = linspace(0,1,360);
    hmap(:,[3]) = 1;
    hmap(:,[2]) = 0.65;
    huemap = hsv2rgb(hmap);
    huemap(end + 1, :) = [0, 0, 0]; 
    
    handle.Visual.ColorMap.Map = huemap;
    handle.Visual.ColorMap.UserRangeMin = limits(1);
    handle.Visual.ColorMap.UserRangeMax = limits(2);
    handle.Visual.ColorMap.UserRange = 1;
%     handle.Visual.ColorMap.MapExpression = 'jet';
    handle.Parent.Position = [100 100 700 550];
end