
clear all
%MPN = GetMyDir
load('MPN.mat')
load([MPN 'cbDat.mat']);
load([MPN 'obI.mat']);
seedList = [108 201];
useList = obI2cellList_seedInput_RGC_TCR(obI,seedList);

%% Get distances to all cell bodies from seed cells
cbID = cbDat.cbID;
cbCenters = cbDat.cbCenters;
cbDists = zeros(length(cbID),length(seedList));
for s = 1:length(seedList)
    targCB = find(cbID == seedList(s));

    cbDists(:,s) = sqrt((cbCenters(:,1)-cbCenters(targCB,1)).^2 + ...
    (cbCenters(:,2)-cbCenters(targCB,2)).^2 + ...
    (cbCenters(:,3)-cbCenters(targCB,3)).^2);

end

%% generate synapse matrix for all cb
synMat = useList.con;
cbSynMat = zeros(length(useList.preList),length(cbID));
for i = 1:length(cbID)
    if cbID(i)>0
        targ = find(useList.postList == cbID(i));
        if ~isempty(targ)
            cbSynMat(:,i) = synMat(:,targ);
        end
    end
end

%% find links to seed
sharedSyn = zeros(length(cbID),length(seedList));
sharedAx = sharedSyn;
for s = 1:length(seedList)
    targCB = find(cbID == seedList(s));
    seedMat = repmat(cbSynMat(:,targCB),[1 length(cbID) ]);
    sharedSyn(:,s) = sum(min(cbSynMat,seedMat),1)';
    sharedAx(:,s) = sum(min(cbSynMat,seedMat)>0,1)'   ; 
end
isLinked = sharedAx>0;

%% Bin distances
binSize = 10;
binRad = binSize/2;
binRange = [binRad:binSize:100];
linkedAt = zeros(length(binRange),length(seedList));
totalAt = linkedAt;
clear groupCells
for i = 1:length(binRange);
    checkPos = binRange(i);
    for s = 1:length(seedList)
        inRange = (cbDists(:,s)>(checkPos-binRad))& (cbDists(:,s)<=(checkPos+binRad));
        linkedAt(i,s) = sum(isLinked(inRange,s));
        totalAt(i,s) = sum(inRange);
        groupCells{i,s}  = find(inRange);
    end
end
    
for s = 1:length(seedList)
    subplot(3,1,s)
    bar(binRange,totalAt(:,s),'b')
    hold on
   bar(binRange,linkedAt(:,s),'r')
   hold off
end

   subplot(3,1,3)
   plot(binRange,linkedAt./totalAt)

   %% Redistribute links
   
   recreateLinks = isLinked * 0;
   for b = 1:size(groupCells,1)
       for s = 1:length(seedList)
           if linkedAt(b,s)
               possible = groupCells{b,s};
               pick  = randperm(length(possible),linkedAt(b,s));
               picked = possible(pick);
               recreateLinks(possible,s) = isLinked(possible,s);
           end
       end
   end
   
   sum(recreateLinks);
   realSame = sum(sum(recreateLinks,2) == 2);
   
   
   reps = 1000;
   
   for r = 1:reps;
   randLinked = isLinked * 0;
   for b = 1:size(groupCells,1)
       for s = 1:length(seedList)
           if linkedAt(b,s)
               possible = groupCells{b,s};
               pick  = randperm(length(possible),linkedAt(b,s));
               picked = possible(pick);
               randLinked(picked,s) = 1;
           end
       end
   end
   
   sum(randLinked);
   randSame(r) = sum(sum(randLinked,2) == 2);
   end
   
   
  mcHistBin = [0:1:30];
  histSame = hist(randSame,mcHistBin);
  bar(mcHistBin,histSame,'y')
  hold on
  scatter(realSame,10,40,'r','filled')
  hold off
  
  
   




