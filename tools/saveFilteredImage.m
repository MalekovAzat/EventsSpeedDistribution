% The function apply filter by timeTreshold and save image to file in calculatedPictures
function saveFilteredImage(matrix, treshold)
    resMatrix = filteredMatrix(matrix, treshold);
    showImage(resMatrix, sprintf('calculatedPictures/fulteredImage_%.1f.png', treshold));