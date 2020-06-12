function [ ] = ShowPlotForBranch(BranchesInfoMap, timeIndex, branchNumber)
    direction = BranchesInfoMap(branchNumber).direction;
    xArray = BranchesInfoMap(branchNumber).lenArray;
    yArray = BranchesInfoMap(branchNumber).speedArray;
    figure;
    plot(xArray, yArray);
    title(sprintf("Branch %u, direction %d, time %d", [branchNumber, fix(rad2deg(direction)), timeIndex]));
    legend("av.speed");
end
