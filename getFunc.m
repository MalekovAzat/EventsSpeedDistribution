function[] = getFunc()
%     fileName = "smooth_color_events2.mat";
%     data = matfile(fileName);
%     data = data.dataMtr;
%     y = [];
%     for i = 1:1500
%         y = [y, data(150,150,i)];
%     end
%     x = 1:1500;
%     plot(x,y);
    plotbaseLine();
end

function[] = plotbaseLine()
    pixelX = 320;
    pixelY = 320;
    lB = 500;
    rB = 700;
    path_prefix = "data/";
    data = matfile(path_prefix + "f_noise_sigma.mat");
    intensityData = matfile(path_prefix+ "df_baseline_video.mat");
    
    noiseSigmaMtr = data.f_noise_sigma;
    intensityDataMtr = intensityData.df_baseline_video;
    
    intensiryFuncArr = [];
    sigmaFuncArr = [];
    for i = lB:rB
        intensiryFuncArr = [intensiryFuncArr,intensityDataMtr(pixelX,pixelY,i)];
        sigmaFuncArr = [sigmaFuncArr,noiseSigmaMtr(pixelX,pixelY)];
    end 
    intersectionPointsX = [];
    intersectionPointsY = [];
    
    for i = lB+1:rB
        leftBorder = intensityDataMtr(pixelX,pixelY,i-1);
        rightBorder = intensityDataMtr(pixelX,pixelY,i);
        noise = noiseSigmaMtr(pixelX,pixelY);
        if(leftBorder < noise) & (noise < rightBorder)       
            x = getSmoothValue(leftBorder,rightBorder,noise);

            intersectionPointsX = [intersectionPointsX, x + i - 1];
            intersectionPointsY = [intersectionPointsY, noise];
        end
    end
    
    x = lB:rB;
    plot(x,intensiryFuncArr);
    hold on; 
    plot(x,sigmaFuncArr);
    hold on;
    plot(intersectionPointsX,intersectionPointsY,"ko");
    legend
    display(intersectionPointsX);
end

function [val] = getSmoothValue(leftBorder,rightBorder, noiseLine)
    aMtr = [0,1;1,1];
    bVect = [leftBorder;rightBorder];
    x = aMtr\ bVect;
    coefA = x(1);
    coefB = x(2);
    xForNoiseValue = (noiseLine - coefB)/coefA;
    val  = xForNoiseValue;
end


