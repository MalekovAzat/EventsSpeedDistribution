function [mtr] = reverseMtr(mtr)
    for t = 1:1500
        for x = 1:512
            for y = 1:512
                if (mtr(x, y, t) ~= 0)
                    mtr(x, y, t) = 1 / mtr(x, y, t);
                end
            end
        end
    end
end
