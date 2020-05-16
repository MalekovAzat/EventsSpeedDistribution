%param[in] dataMtr = 512x512 matrix 
function [] = showImage(dataMtr)
    cmap = jet(256);
    imagesc(dataMtr);
end
