

if 0
    clear all
    load('MPN.mat');
    load([MPN 'obI.mat']);
    targCell = 125;
    maxDist = 5;
    iptsetpref('ImshowBorder','tight');
    load('D:\LGNs1\Analysis\sm.mat')    
end


isAx = sm.isAx
nodeNum = length(isAx);
skel2skel = sm.skel2skel.linDist;
pos =  sm.skelPos;
dists = sqrt((pos(:,1)-pos(:,1)').^2 + (pos(:,2)-pos(:,2)').^2 + ...
    (pos(:,3)-pos(:,3)').^2);


%% Get ax stats
axNodes = find(isAx);
axTip = find(sm.dist2body(axNodes) == max(sm.dist2body(axNodes)),1);
axSize = length(axNodes);



%% break arbor into potential axons

openNode = ones(size(sm.isAx))>0;
c = 0;
clf, hold on, set(gca,'clipping','off')
scatter3(pos(:,1),pos(:,2),pos(:,3),'.','k')
clear likeAx
for i = 1:1000
    
    
    openList = find(openNode);
    furthest = openList(find(sm.dist2body(openList) == max(sm.dist2body(openList)),1));
    if isempty(furthest)
        break
    end
    openNode(furthest) = 0;
    distFromTip = skel2skel(furthest,:);
    [sortDists idxA] = sort(distFromTip,'ascend');
    scatter3(pos(furthest,1),pos(furthest,2),pos(furthest,3),20,'o','r','filled')
    
%     %idxA = 1:10000;
%     for n = 1:length(idxA)
%         scatter3(pos(idxA(n),1),pos(idxA(n),2),pos(idxA(n),3),20,'o','g','filled')
%         pause(.01)
%     end
    
    closeChunk = idxA(1:axSize);
    col = rand(1,3); col = col-min(col); col = col/ max(col);
    scatter3(pos(closeChunk,1),pos(closeChunk,2),pos(closeChunk,3),20,'o','filled',...
        'markerfacecolor',col)

    pause(.01)
    openNode(closeChunk) = 0;
    likeAx(i,:) = closeChunk;
end


%% Get RGC synapses

rgcInd = find((sm.syn2skel.post == 125) & ( sm.syn2skel.preClass == 1));
rgcNodes = sm.syn2skel.closestSkel(rgcInd);
rgcPos = pos(rgcInd,:);
rgcNum = length(rgcInd);

clf, hold on, set(gca,'clipping','off')
scatter3(pos(:,1),pos(:,2),pos(:,3),'.','k')
scatter3(pos(rgcNodes,1),pos(rgcNodes,2),pos(rgcNodes,3),'o','filled',...
    'markerfacecolor','g');

uRgcNodes = unique(rgcNodes);
countNodes = hist(rgcNodes,uRgcNodes);
lookupRGC = zeros(size(isAx));
lookupRGC(uRgcNodes) = countNodes;

rgcNumAll = lookupRGC(likeAx);
numRGC = sum(rgcNumAll,2);
minNum = min(numRGC);

%% randomize
reps = 10000
randMinNum = zeros(reps,1);
for r = 1:reps
    randNodes = ceil(rand(rgcNum,1)*nodeNum);
    
%     clf, hold on, set(gca,'clipping','off')
%     scatter3(pos(:,1),pos(:,2),pos(:,3),'.','k')
%     scatter3(pos(randNodes,1),pos(randNodes,2),pos(randNodes,3),'o','filled',...
%     'markerfacecolor','g');
    uRgcNodes = unique(randNodes);
    countNodes = hist(randNodes,uRgcNodes);
    lookupRGC = zeros(size(isAx));
    lookupRGC(uRgcNodes) = countNodes;
 
    rgcNumAll = lookupRGC(likeAx);
    numRGC = sum(rgcNumAll,2);
    randMinNum(r) = min(numRGC);
    pause(.01)
    
end


%% results

reps
minNum
axLikeSize = size(likeAx,1)
sortRes = sort(randMinNum,'ascend');
mean(sortRes)
CI95 = [sortRes(round(reps * .025))  sortRes(round(reps * .975))]
P = mean(sortRes<=minNum)




