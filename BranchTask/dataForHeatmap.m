%the function create data for heatmap - matrix with size (1500, branch lane)

function [matrix] = dataForHeatmap(pointsMap, eventsMatrix, branchIndex, timeInterval)
    startTime = timeInterval(1);
    endTime = timeInterval(2);
    matrix = [];
    for i = 1 : endTime - startTime + 1
        index = i + startTime - 1;
        branchMap = BranchesSpeed(eventsMatrix(:,:,index), pointsMap, 8, branchIndex);
        speedArr = branchMap(branchIndex).speedArray;
        matrix = [matrix; speedArr];
%         disp(i + startTime - 1);
    end
end