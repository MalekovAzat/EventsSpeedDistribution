%The function takes:
%  - mtr to cut 512x512x1500
% - noize matrix 512x512 
% - intensMtr 512x512x1500
% cut method: if the intencity value more than noiseMtr then continue
% event's live 
% else - kill him

function [mtr1] = cutOffNoise(mtr1, noiseMtr, intensMtr)
    for z = 2:1500
        for x = 1:512
            for y = 1:512
                if (mtr1(x, y, z) == 1)
                    if intensMtr(x, y, z) > noiseMtr(x, y)
                        mtr1(x, y, z) = mtr1(x, y, z - 1) + 1;
                    else
                        mtr1(x, y, z) = 0;
                    end
                end
            end
        end
    end
end
