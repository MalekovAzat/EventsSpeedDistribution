function []  = showIntenceWithBranches(intenseMtr, branchMap)
    mapKeys = keys(branchMap);
    mtr = intenseMtr;
    for keyIndex = 1 : size(mapKeys, 2)
        internalKey = mapKeys(keyIndex);
        internalKey = internalKey{1};

        tmpFilter = filterforBranch(branchMap(internalKey).branchMatrix);

        mtr = mtr.* tmpFilter;
    end

    imagesc(mtr)
end