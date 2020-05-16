function [mtr] = fillIntenseMtr(mtr,data)
    for z = 1:1500
        for x = 1:512
            for y = 1:512
                mtr(x,y,z) = data(x,y,z);
            end
        end
    end
end