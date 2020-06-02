function [] = AngleAndSpeedMovie(matrix, start, stop)
    % sizeX = size(matrix, 1);
    % sizeY = size(matrix, 2);
    % angles = zeros(sizeX, sizeY, stop - start);
    % speeds = zeros(sizeX, sizeY, stop - start);
     hmap(1:255,1) = linspace(0,1,255);
     hmap(:,[3]) = 1;
     hmap(:,[2]) = 0.65;
     huemap = hsv2rgb(hmap);
     huemap(end + 1, :) = [0, 0, 0];

    for timeIndex = 1:stop - start + 1
        [angles, speeds] = AnglesForEachPixel(matrix(:,:,timeIndex + start - 1), matrix(:,:,timeIndex + start - 1), 93, 0.7, 0.4, 8);
%         rgbImage = ind2rgb(angles, huemap);
        imwrite(im2uint8(angles./(2*pi)), huemap, sprintf('AnglesImages/AnglesForFrame_%.0f.png', timeIndex + start - 1));
        
        imwrite(im2uint8(speeds./max(speeds(:))), jet(256), sprintf('SpeedImages/SpeedForFrame_%.0f.png', timeIndex + start - 1));

    end
end