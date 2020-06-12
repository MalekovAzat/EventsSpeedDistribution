function [filterMatrix] = filterforBranch(branchImage)
    filterMatrix = zeros(512, 512);
    for x = 1: 512
        for y = 1:512
            if branchImage(x,y) > 0
                filterMatrix(x,y) = 0;
            else
                filterMatrix(x,y) = 1;
            end
        end
    end
end