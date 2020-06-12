function [speedMatrix, branchesMatrix] = speedMatrixForAllBranches(branchMap)
    mapKeys = keys(branchMap);
    speedMatrix = zeros(512, 512);
    branchesMatrix = zeros(512, 512);
    for keyIndex  = 1 : size(mapKeys, 2)
        internalKey = mapKeys(keyIndex);
        internalKey = internalKey{1};
        speedMatrix = speedMatrix + branchMap(internalKey).speedMatrix;
        branchesMatrix = branchesMatrix + branchMap(internalKey).branchMatrix;
    end
end