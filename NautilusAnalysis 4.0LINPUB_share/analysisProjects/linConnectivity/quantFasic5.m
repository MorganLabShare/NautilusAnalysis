


if 0
    clear all
    
    obMovDir = 'D:\LGNs1\Analysis\movies\subLin125_TargFac\'
    if ~exist(obMovDir,'dir'),mkdir(obMovDir),end
    % else
    %     'directory already exists'
    %     return
    % end
    
    load('MPN.mat')
    load([MPN 'obI.mat'])
    load([MPN 'dsObj.mat'])
    
       load('D:\LGNs1\Analysis\sm.mat')

end
allSub = double(sm.subs)*obI.em.dsRes(1);


%% break skeleton into neurites

nodes = sm.skelNodes;
nodeDegree = zeros(length(nodes),1);
for i = 1:length(nodes) %% get node degree
    nodeDegree(i) = sum(sm.skelEdges(:)==nodes(i));
end
branchPoints = nodes(nodeDegree>2);
runNodes = nodes(nodeDegree<3);


%%Identify edges at branches
branchEdges = sm.skelEdges * 0;
for i = 1:length(branchPoints)
    branchEdges = branchEdges + (sm.skelEdges == branchPoints(i));
end

hasBranch = sum(branchEdges,2)>0;
branches = sm.skelEdges(~hasBranch,:); %% get edges that are not branched



%%connect runs
runNodes2 = unique(branches(:));
runPos = zeros(length(runNodes),3);
for i = 1:length(runNodes)
    runPos(i,:) = sm.skelPos(sm.skelNodes == runNodes(i),:);
end

nodeRunID = runNodes * 0; %assine neurite id to each node.
edgeRunID = zeros(size(branches,1),1);

subplot(1,1,1)
clf, hold on
c = 0; % runID
colMap = hsv(256);
for i = 1:length(runNodes)
    sprintf('%d of %d',i,length(runNodes))
    if nodeRunID(i) == 0 % if has not been assigned yet
        c = c+1;
        lastNode = runNodes(i);
        col = colMap(ceil(rand*256),:);
        while ~isempty(lastNode)
            nextNode = [];
            for n = 1:length(lastNode)
                nodeRunID(runNodes == lastNode(n)) = c; %record run of node being searched
                hit1 = (branches(:,1) == lastNode(n)) & (edgeRunID == 0);
                
                hit2 = (branches(:,2) == lastNode(n)) & (edgeRunID == 0);
                edgeRunID(hit1 | hit2) = c;
                hitN1 = branches(hit1,2);
                hitN2 =  branches(hit2,1);
                %plot(sm.skelPos([hitN1 hitN2],2),sm.skelPos([hitN1 hitN2],1),'color',col),
%                 scatter(sm.skelPos([hitN1 hitN2],2),sm.skelPos([hitN1 hitN2],1),'markerfacecolor',col,'marker','.','markeredgecolor',col);
%                
%                 
%                 hold on
                nextNode = cat(1,nextNode(:),hitN1 ,hitN2);
            end
            lastNode = nextNode;
        end
    end
end
runNum = c;
hold off
 pause(1)
 
 clf
 hold on
for i = 1:max(nodeRunID)
        col = colMap(ceil(rand*256),:);
    scatter(sm.skelPos(runNodes(nodeRunID==i),1),sm.skelPos(runNodes(nodeRunID==i),2),'markerfacecolor',col,'marker','.','markeredgecolor',col) 
 
end
   pause(.01)

%% gets subs of branches
subRunID = zeros(size(allSub,1),1);
% 
% L = size(allSub,1);
% bin = 10000;
% divs = [0:bin:L L];
% for i = 1:length(divs)-1
%     sprintf('%d of %d',i,length(divs)-1)
%     check = [divs(i)+1:divs(i+1)];
%     dif = cat(3,allSub(check,1)-runPos(:,1)',allSub(check,2)-runPos(:,2)',allSub(check,3)-runPos(:,3)');
%     dists = sqrt(sum(dif.^2,3));
%     minDists = repmat(min(dists,[],2),[1 size(dists,2)]);
%     [y x] = find(minDists == dists);
% %     targ = find(dists == min(dists),1);
% %     subRunID(check) = nodeRunID(targ);
%     subRunID(y) = nodeRunID(x);
% 
% end


for i = 1:size(allSub,1)
  if ~mod(i,1000); sprintf('%d of %d',i,size(allSub,1)), end
    dists = sqrt((allSub(i,1) - runPos(:,1)).^2 + (allSub(i,2) - runPos(:,2)).^2 + ...
        (allSub(i,3) - runPos(:,3)).^2);
    targ = find(dists == min(dists),1);
    subRunID(i) = nodeRunID(targ);
    
end


%% Show branches
if 0
    colors = hsv(100);
    
    hold off
    subplot(1,1,1)
    clf
    %scatter3(allSub(:,1),allSub(:,2),allSub(:,3),'.')
    hold on
    
    for i = 1:runNum
                col = colMap(ceil(rand*256),:);

        %scatter3(runPos(nodeRunID == i,1),runPos(nodeRunID == i,2),runPos(nodeRunID == i,3),'.')
        scatter3(allSub(subRunID == i,1),allSub(subRunID == i,2),allSub(subRunID == i,3),'.','markeredgecolor',col)
        pause(.01)
    end
    
    hold off
    pause(.01)
    
    subplot(1,1,1)
    clf
    hold on
    for i = 1:runNum
        branch = find(edgeRunID == i);
        col = colors(ceil(rand*100),:);
        for b = 1:length(branch)
            plot3(sm.skelPos(branches(branch(b),:),1),...
                sm.skelPos(branches(branch(b),:),2), sm.skelPos(branches(branch(b),:),3),'color',col);
        end
    end
    hold off
    pause(.1)
    
end

branchesL = sqrt((sm.skelPos(branches(:,1),1) - sm.skelPos(branches(:,2),1)).^2 + ....
    (sm.skelPos(branches(:,1),2) - sm.skelPos(branches(:,2),2)).^2 + ...
    (sm.skelPos(branches(:,1),3) - sm.skelPos(branches(:,2),3)).^2);
for i = 1:runNum
    runL(i) = sum(branchesL(edgeRunID==i));
end
hist(runL,1:2.5:100)
hist(edgeRunID,unique(edgeRunID))

%%
fascicDist = 10;

distRange = [0:.2:20];
distBin = .5;


targCell = 125;
filtPre = sm.pre == targCell;
filtPost = sm.postClass == 2;

testSyn = find(filtPre & filtPost);

voxSiz = 1;

targSub = double(sm.subs(sm.subType == 1,:))*obI.em.dsRes(1);
axSub = double(sm.subs(sm.subType == 2,:))*obI.em.dsRes(1);
shaftSub = double(sm.subs(sm.subType == 3,:))*obI.em.dsRes(1);

typeSub{1} = targSub;
typeSub{2} = axSub;
typeSub{3} = shaftSub;

clear typeDist synRunID synType trackRanges
closePlot = zeros(length(testSyn),length(distRange));
trackRangesTarget = closePlot;
trackRangesPre = closePlot;

goodTest = testSyn * 0;
for i = 1:length(testSyn)
    
    sprintf('running %d of %d',i,length(testSyn))
    
    synPos = sm.pos(testSyn(i),:);
    postID = sm.post(testSyn(i),:);
    
    %Find process type
    typeDist{1} = min(sqrt((targSub(:,1)-synPos(1)).^2 + ...
        (targSub(:,2)-synPos(2)).^2 + (targSub(:,3)-synPos(3)).^2));
    typeDist{2}  = min(sqrt((axSub(:,1)-synPos(1)).^2 + ...
        (axSub(:,2)-synPos(2)).^2 + (axSub(:,3)-synPos(3)).^2));
    typeDist{3}  = min(sqrt((shaftSub(:,1)-synPos(1)).^2 + ...
        (shaftSub(:,2)-synPos(2)).^2 + (shaftSub(:,3)-synPos(3)).^2));
    
    
    %%Find nearest branch
    runDists = sqrt((runPos(:,1)-synPos(1)).^2 + ...
        (runPos(:,2)-synPos(2)).^2 + (runPos(:,3)-synPos(3)).^2);
    synRunID(i) = nodeRunID(find(runDists == min(runDists),1)); %get run ID of closest run
    
    minType = [typeDist{1} typeDist{2} typeDist{3}];
    synType(i) = find(minType == min(minType),1);
    
    
    
    %     subDist  = (sqrt((allSub(:,1)-synPos(1)).^2 + ...
    %         (allSub(:,2)-synPos(2)).^2 + (allSub(:,3)-synPos(3)).^2)); %distance of targ cell to synapse
    
    if 1 % check subs of that type
        preSub = typeSub{synType(i)};
    elseif 1 %check subs of that branch
        %preSub = runPos(nodeRunID == synRunID(i),:);
        preSub = allSub(subRunID == synRunID(i),:);
    else %use all presynaptic subs
        preSub = allSub;
    end
    
    subDist  = (sqrt((preSub(:,1)-synPos(1)).^2 + ...
        (preSub(:,2)-synPos(2)).^2 + (preSub(:,3)-synPos(3)).^2)); %distance of targ cell to synapse
    
    checkSub = find(subDist<=fascicDist*2); %Pre cell 125 subs
    %restrict to neurite
    sameNeurite = find(subRunID == synRunID(i));
    %checkSub = intersect(checkSub,sameNeurite);
    
    subCell = names2Subs(obI,dsObj,postID);
    subTarg = double(subCell{1})*obI.em.dsRes(1);
    
    targSubDist  = (sqrt((subTarg(:,1)-synPos(1)).^2 + ...
        (subTarg(:,2)-synPos(2)).^2 + (subTarg(:,3)-synPos(3)).^2));
    subTarg = subTarg(targSubDist <=(fascicDist*2),:); %positions of nearby pieces of targeted cells
    closeSub = preSub(checkSub,:); %position of all nearby pieces of target cell
    
    
    if ~isempty(subTarg) & ~isempty(closeSub)
        goodTest(i) = 1;
        clear targDist
        tic
        for s = 1:length(checkSub)
            cSub = closeSub(s,:);
            targDist(s)  = min(sqrt((subTarg(:,1)-cSub(1)).^2 + ...
                (subTarg(:,2)-cSub(2)).^2 + (subTarg(:,3)-cSub(3)).^2));
        end
        toc
        
        closeDist = subDist(checkSub); %distance of nearby target TC to synapse
        
        
        %%Analyze
        
        closest = distRange * 0;
        clear trackRangePre trackRangeTarget 
        for d = 1:length(distRange) %run through distances to filter target cell positions
            
            isRange = (closeDist >= (distRange(d)-distBin)) & ...
                (closeDist < (distRange(d) + distBin));
            trackRangePre(d) = sum(isRange);
            
            isRangeTarget = (targSubDist >= (distRange(d)-distBin)) & ...
                (targSubDist < (distRange(d) + distBin));
            trackRangeTarget(d) = sum(isRangeTarget);
            
            if sum(isRange)
                closest(d) = min(targDist(isRange')); %find closest position of targ to post cell
            else
                goodTest(i) = 0;
            end
        end
        
        
        closePlot(i,:) = closest;
        trackRangesTarget(i,:) = trackRangeTarget;
        trackRangesPre(i,:) = trackRangePre;
        
        if synType(i) == 1
            col = 'g';
        elseif synType(i) == 3
            col = 'c';
        elseif synType(i) == 2
            col = 'm';
        else
            col = 'y';
        end
        
        if 1 %~mod(i-1,10)
            subplot(1,2,1)
            scatter3(subTarg(:,1),subTarg(:,2),subTarg(:,3),'.','b')
            daspect([1 1 1])
            hold on
            scatter3(closeSub(:,1),closeSub(:,2),closeSub(:,3),'.',col)
            scatter3(synPos(:,1),synPos(:,2),synPos(:,3),200,'s','filled','g')
            hold off
            subplot(1,2,2)
            hold off
            plot(distRange,closest,'color','r','linewidth',5)
            hold on
            scatter(closeDist,targDist,'.','b');
            
            ylim([0 fascicDist]);
            xlim([0 fascicDist]);
            pause(.01)
        end
        
        if mean(closest< closeEnough)>0.9
            closest
            pause
        end
        
    else
        'missing positions'
    end
end






%%

scatter(sm.pos(testSyn(synType == 1),1),sm.pos(testSyn(synType == 1),2),'.','g')
hold on
scatter(sm.pos(testSyn(synType == 2),1),sm.pos(testSyn(synType == 2),2),'.','r')
scatter(sm.pos(testSyn(synType == 3),1),sm.pos(testSyn(synType == 3),2),'.','b')

hold off


%% Analyze
closeEnough = 1;


%% run Length


countMat = repmat(1:size(closePlot,2),[size(closePlot,1) 1]);
countMat(closePlot<closeEnough)  = inf;
facLength = min(countMat,[],2)-1;
facLength(facLength == Inf) = size(closePlot,2);

%%Get extent of pre neurite measured
countMat = repmat(1:size(closePlot,2),[size(closePlot,1) 1]);
countMat(trackRangesPre>0)  = inf;
preLength = min(countMat,[],2)-1;
preLength(preLength == Inf) = size(closePlot,2);




facLength1 = facLength(synType == 1);
facLength3 = facLength(synType == 3);
preLength1 = preLength(synType == 1);
preLength3 = preLength(synType == 3);

bins = 1:size(closePlot,2);
histFacLength1 = hist(facLength1,bins);
histFacLength3 = hist(facLength3,bins);
histPreLength1 = hist(preLength1,bins);
histPreLength3 = hist(preLength3,bins);

cumPreLength1 = cumsum(histPreLength1,'reverse');
cumPreLength3 = cumsum(histPreLength3,'reverse');
cumFacLength1 = cumsum(histFacLength1,'reverse');
cumFacLength3 = cumsum(histFacLength3,'reverse');


plot(histFacLength1,'g')
hold on
plot(histFacLength3,'b')
hold off


plot(cumFacLength1./cumPreLength1,'g')
hold on
plot(cumFacLength3./cumPreLength3,'b')
hold off




return

%%

closeTarg =  closePlot((synType' == 1) & goodTest,:);
closeShaft =  closePlot((synType' == 3) & goodTest,:);






L = size(closeTarg,1);
sortClose = sort(closeTarg,1,'ascend');
targ05 = sortClose(round(L*.05),:);
targ50 = sortClose(round(L*.50),:);
targ95 = sortClose(round(L*.95),:);
targ025 = sortClose(round(L*.025),:);
targ975 = sortClose(round(L*.975),:);



L = size(closeShaft,1);
sortClose = sort(closeShaft,1,'ascend');
shaft05 = sortClose(round(L*.05),:);
shaft50 = sortClose(round(L*.50),:);
shaft95 = sortClose(round(L*.95),:);
shaft975 = sortClose(round(L*.975),:);
shaft025 = sortClose(round(L*.025),:);


hold off
plot(distRange,targ025,'g')
hold on
plot(distRange,targ50,'color','g','linewidth',5)
plot(distRange,targ975,'g')
plot(distRange,shaft025,'r')
plot(distRange,shaft50,'color','r','linewidth',5)
plot(distRange,shaft975,'r')

hold off

%% Test fasci
%definition is amount of neurite within 1um 5-15 um from synapse

sampRange = [1 distRange(end)+distBin];
sampTarg = closeTarg(:,(distRange>sampRange(1)) & (distRange <= sampRange(2)))<=closeEnough;
sampShaft = closeShaft(:,(distRange>sampRange(1)) & (distRange <= sampRange(2)))<=closeEnough;

meanTarg = mean(sampTarg,2);
meanShaft = mean(sampShaft,2);
meanRange = [0 1];
histMeanTarg = hist(meanTarg,meanRange)/length(meanTarg)
histMeanShaft = hist(meanShaft,meanRange)/length(meanShaft)

bar(meanRange,[histMeanShaft; histMeanTarg]')

%% Calculate fasciculation of neurites
aveFac = mean((closePlot(:,(distRange>sampRange(1)) & (distRange <= sampRange(2)))<=closeEnough),2);

maxRunFac = zeros(runNum,1);
runType = zeros(runNum,3);
for i = 1: runNum
    synOnRun = find(synRunID==i);
    numSynOnRun(i) = length(synOnRun);
    if ~isempty(synOnRun)
        maxRunFac(i) = max(aveFac(synOnRun));
    end
    rN = runNodes(nodeRunID == i);
    runType(i,:) = [sum(sm.isTarg(rN)) sum(sm.isAx(rN)) sum(sm.isShaft(rN))];
end
runTypeRat = runType./repmat(sum(runType,2),[1 3]);

targBranch = runTypeRat(:,1)> 0.8;
longEnough = runL >= sampRange(end);

isFac = (targBranch(:) & longEnough(:) & (maxRunFac(:)>0) & (numSynOnRun(:)>0));
notFac = (targBranch(:) & longEnough(:) & (maxRunFac(:)==0) & (numSynOnRun(:)>0));
totIsFac = sum(isFac)
totNotFac = sum(notFac);
totFac = sum(isFac + notFac)

subplot(1,1,1)
clf
hold on
colors = [isFac notFac notFac * 0];
for i = 1:runNum
    branch = find(edgeRunID == i);
    col = colors(ceil(rand*100),:);
    for b = 1:length(branch)
        plot3(sm.skelPos(branches(branch(b),:),1),...
            sm.skelPos(branches(branch(b),:),2), sm.skelPos(branches(branch(b),:),3),'color',colors(i,:),...
            'linewidth',2);
    end
end

hold off
pause(.1)

%%Quick boot
numA = 51; numB = 52; hitA = 22; hitB = 11;
all = zeros(numA + numB,1);
all(1:(hitA+hitB)) = 1;
reps = 100000;
for r = 1:reps
    
    randAll =all(randperm(length(all)));
    
   hitAR(r) = sum(randAll(1:numA));
   hitBR(r) = sum(randAll(numA+1:end));
end

realDif = hitB-hitA;
randDif = hitBR-hitAR;

P = mean(randDif<=realDif)




%% p
subplot(1,1,1)
closestRange = [0:.5:5];
histShaft = hist(closeShaft(:,end),closestRange)/sum(histShaft);
histTarg = hist(closeTarg(:,end),closestRange)/sum(histTarg);
bar(closestRange,[histTarg' histShaft'])
hold on
bar(closestRange +.2,histShaft,'r')

hold off

realDif = shaft50(end) - targ50(end);
realFacDif = mean(closeTarg(:,end)<1) - mean(closeShaft(:,end)<1) ;
mean(closeTarg(:,end)<1)
mean(closeShaft(:,end)<1)


%%

reps = 100000;
for r = 1:reps
    choosen = randperm(length(synType));
    randSyn =  synType(choosen);
    closeTarg =  closePlot((synType(randSyn)' == 1) & goodTest(randSyn),:);
    closeShaft =  closePlot((synType(randSyn)' == 3) & goodTest(randSyn),:);
    testTarg(r) = median(closeTarg(:,end));
    testShaft(r) = median(closeShaft(:,end));
    randFacDif(r) = mean(closeTarg(:,end)<1) - mean(closeShaft(:,end)<1) ;
    
end
randDif = testShaft-testTarg;


P = sum(randDif>=realDif)/length(randDif)
Pfac = sum(randFacDif>=realFacDif)/length(randDif)

%
% hold off
% lineCol = [0 1 0; 1 0 0; 0 0 1; 0 0 0; 0 0 0; 0 0 0];
% for i = 1:length(synType)
%     plot(distRange,closePlot(i,:),'color',lineCol(synType(i),:),'linewidth',1)
%     hold on
% end
%











