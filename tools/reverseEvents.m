% the function reverses each pixel from X to 1/X
function [mtr] = reverseEvents(mtr, strictFilter)
if nargin < 2
    strictFilter = false;
end
for t = 1:1500
    for x = 1:512
        for y= 1:512
            if strictFilter
                if mtr(x,y,t) > 1
                    mtr(x,y,t) = 1/mtr(x,y,t);
                elseif ((mtr(x,y,t) < 1) && (mtr(x,y,t) > 0))
                    mtr(x,y,t) = 1;
                end
            else
                if mtr(x,y,t) > 0
                    mtr(x,y,t) = 1/mtr(x,y,t);
                end
            end
        end
    end
end
end
