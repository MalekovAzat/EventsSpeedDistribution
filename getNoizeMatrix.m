%Return noiseMatrix 
% fileName and corellCoeff (equal to 1) are needed
function [noiseMatrix] = getNoizeMatrix(fileName, corellCoeff)
    data = matfile(fileName);
    noiseMatrix = data.f_noise_sigma;
    noiseMatrix = noizeMatrix * corellCoeff;
end
