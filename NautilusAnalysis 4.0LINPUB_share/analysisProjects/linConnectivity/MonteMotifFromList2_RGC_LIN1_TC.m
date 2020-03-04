
if 0
    clear all
    load(['D:\LGNs1\Analysis\motifImages\listMotifWorkSpace.mat'])
    
    obMovDir = 'D:\LGNs1\Analysis\movies\subLin125_TargFac\'
    if ~exist(obMovDir,'dir'),mkdir(obMovDir),end
    % else
    %     'directory already exists'
    %     return
    % end
    
    load('MPN.mat')
    load([MPN 'obI.mat'])
    load([MPN 'dsObj.mat'])
    % save('D:\LGNs1\Analysis\motifImages\listMotifWorkSpace2.mat','-v7.3')
    load(['D:\LGNs1\Analysis\motifImages\listMotifWorkSpaceR3.mat'])
    load('D:\LGNs1\Analysis\sm.mat')
    
end



%% get motifs
nodeNum = length(sm.skelNodes);
nodeProcType = sm.isTarg + sm.isAx * 2 + sm.isShaft * 3 + sm.isBody * 4;
motifCodes = [...
    '1 = RGC only, 2 = TC only, 3 = LINin only, 4 = LINout only, 5 = UNKin only, ' ...
    '6 = recip, 7 = autapse,'...
    '8 = RGC-LIN-TC diad, 9 = RGC-LIN-TC triad, 10 = RGC-LIN-TC mult triad, ' ...
    '11 = RGC-LIN-LIN diad, 12 = RGC-LIN-LIN IN triad,  13 = RGC-LIN-LIN out triad, 14 = RGC-LIN-LIN recip triad, ' ...
    '15 = LIN1-LIN-TC diad (top), 16 = LIN-LIN1-TC diad (mid), '...
    '17 = LIN1-LIN-TC triad(top), 18 = LIN-LIN1-TC triad(mid), 19 = LIN-LIN-TC recip triad, '...
    '20 = LLL diad, 21 = LLL tri top, 22 = LLL tri mid, 23 = LLL tri bot, 24 = LLL recip triad, '...
    '25 = UNK-LIN-TC(diad), 26 = UNK-LIN-TC triad, 27 = LIN-TC without RGC, 28 = LIN-TC with near RGC, diad' ...
    '29 = RGC any'];

group1 = [2];
group2 = [8 9];
%group1 = [15 17]
pos1 = cat(1,mPos{group1})
pos2 = cat(1,mPos{group2});

pos = cat(1,pos1,pos2);
type = cat(1,ones(size(pos1,1),1),ones(size(pos2,1),1)* 2);
num = size(pos,1);

scatter(pos(:,2),pos(:,1))


%%motif to skeleton
mot2skel = zeros(num,1);
for i = 1:num
    
    dists = sqrt((sm.skelPos(:,1)-pos(i,1)).^2 + ...
        (sm.skelPos(:,2)-pos(i,2)).^2 + ...
        (sm.skelPos(:,3)-pos(i,3)).^2);
    
    
    mot2skel(i) = find(dists==min(dists),1);
    
end

scatter(sm.skelPos(sm.isAx,2),sm.skelPos(sm.isAx,1),'.','r')
hold on
scatter(sm.skelPos(sm.isTarg,2),sm.skelPos(sm.isTarg,1),'.','g')
scatter(sm.skelPos(sm.isShaft,2),sm.skelPos(sm.isShaft,1),'.','b')
scatter(sm.skelPos(mot2skel(type==1),2),sm.skelPos(mot2skel(type==1),1),'o','filled','m')
scatter(sm.skelPos(mot2skel(type==2),2),sm.skelPos(mot2skel(type==2),1),'o','filled','c')

hold off
pause(.1)

%% Measure real

s1 = sm.skelPos(sm.skelEdges(:,1),:);
s2 = sm.skelPos(sm.skelEdges(:,2),:);

skelLengths = sqrt((s1(:,1)-s2(:,1)).^2 + (s1(:,2)-s2(:,2)).^2 +(s1(:,3)-s2(:,3)).^2);
skelPos =(s1 + s2)/2;

shaftNodes = find(sm.isShaft);
targNodes = find(sm.isTarg);
axNodes = find(sm.isAx);

procType = zeros(size(sm.skelPos,1),1);
procType(sm.isShaft) = 1;
procType(sm.isTarg) = 2;
procType(sm.isAx) = 3;

typeForMot1 = procType(mot2skel(type == 1));
typeForMot2 = procType(mot2skel(type == 2));

onShaft1 = sum(typeForMot1==1)
onTarg1 = sum(typeForMot1==2)
onAx1 = sum(typeForMot1==3)
onShaft2 = sum(typeForMot2==1)
onTarg2 = sum(typeForMot2==2)
onAx2 = sum(typeForMot2==3)


shaftRat = onShaft1/(onShaft1+onShaft2);
targRat = onTarg1/(onTarg1+onTarg2);
axRat = onAx1/(onAx1 + onAx2);

ratDif = targRat - shaftRat;

onShell1 = sum((sm.skelPos(mot2skel(type == 1),1)<250));
onCore1 = sum((sm.skelPos(mot2skel(type == 1),1)>300)) ;
onShell2 = sum((sm.skelPos(mot2skel(type == 2),1)<250));
onCore2 = sum((sm.skelPos(mot2skel(type == 2),1)>300)) ;
isShell = sum(( sm.skelPos(:,1)<250));
isCore = sum((sm.skelPos(:,1)>300)) ;
lengthShell = sum(skelLengths(skelPos(:,1) <250));
lengthCore = sum(skelLengths(skelPos(:,1) >300));


% normalLength = sum(skelLengths)./length(skelLengths);
% lengthShell = isShell * normalLength;
% lengthCore = isCore * normalLength;

lengthAll = sum(skelLengths);

shellRat = onShell1/(onShell1 + onShell2);
coreRat = onCore1/(onCore1 + onCore2);

motDensityShell = onShell1/lengthShell;
motDensityCore = onCore1/lengthCore;

scDensRes = motDensityShell/motDensityCore


%% Monte
reps = 1000;

onShaftRand = zeros(1,reps);
onTargRand = zeros(1,reps);
onAxRand = zeros(1,reps);

onShaft1Rand = zeros(reps,1); onTarg1Rand= zeros(reps,1);  coreRatRand = zeros(reps,1); shellRatRand = zeros(reps,1);
onCore2Rand = zeros(reps,1); onShell2Rand = zeros(reps,1); onShell2Rand = zeros(reps,1);
onCore1Rand = zeros(reps,1);  onShell1Rand = zeros(reps,1); axRatRand = zeros(reps,1);
targRatRand = zeros(reps,1); shaftRatRand = zeros(reps,1); onAx2Rand = zeros(reps,1); onTarg2Rand = zeros(reps,1);
onShaft2Rand = zeros(reps,1); onAx1Rand = zeros(reps,1); onTarg1Rand = zeros(reps,1); onShaft1Rand = zeros(reps,1);

clear onShaft1Rand onTarg1Rand onAx1Rand onShaft2Rand onTarg2Rand onAx2Rand
clear shaftRatRand  targRatRand axRatRand onShell1Rand onCore1Rand onShell2Rand onCore2Rand
clear motDensityShellRand motDensityCoreRand shellRatRand coreRatRand
for r = 1:reps
    r
    mot2skelRand = randperm(size(sm.skelPos,1),num);
    
    
    
    
    scatter(sm.skelPos(sm.isAx,2),sm.skelPos(sm.isAx,1),'.','r')
    hold on
    scatter(sm.skelPos(sm.isTarg,2),sm.skelPos(sm.isTarg,1),'.','g')
    scatter(sm.skelPos(sm.isShaft,2),sm.skelPos(sm.isShaft,1),'.','b')
    scatter(sm.skelPos(mot2skelRand,2),sm.skelPos(mot2skelRand,1),'o','filled','m')
    hold off
    pause(.1)
    
    
    onShaft1Rand(r) = length(intersect(shaftNodes,mot2skelRand(type == 1)));
    onTarg1Rand(r) = length(intersect(targNodes,mot2skelRand(type == 1)));
    onAx1Rand(r) = length(intersect(axNodes,mot2skelRand(type == 1)));
    onShaft2Rand(r) = length(intersect(shaftNodes,mot2skelRand(type == 2)));
    onTarg2Rand(r) = length(intersect(targNodes,mot2skelRand(type == 2)));
    onAx2Rand(r) = length(intersect(axNodes,mot2skelRand(type == 2)));
    
    shaftRatRand(r) = onShaft1Rand(r)/(onShaft1Rand(r)+onShaft2Rand(r));
    targRatRand(r) = onTarg1Rand(r)/(onTarg1Rand(r)+onTarg2Rand(r));
    axRatRand(r) = onAx1Rand(r)/(onAx1Rand(r) + onAx2Rand(r));
    
    
    onShell1Rand(r) = sum((sm.skelPos(mot2skelRand(type == 1),1)>0) & ( sm.skelPos(mot2skelRand(type == 1),1)<250));
    onCore1Rand(r) = sum((sm.skelPos(mot2skelRand(type == 1),1)>300)) ;
    onShell2Rand(r) = sum((sm.skelPos(mot2skelRand(type == 2),1)>0) & ( sm.skelPos(mot2skelRand(type == 2),1)<250));
    onCore2Rand(r) = sum((sm.skelPos(mot2skelRand(type == 2),1)>300)) ;
    
    motDensityShellRand(r) = onShell1Rand(r)/lengthShell;
    motDensityCoreRand(r) = onCore1Rand(r)/lengthCore;
    
    shellRatRand(r) = onShell1Rand(r)/(onShell1Rand(r) + onShell2Rand(r));
    coreRatRand(r) = onCore1Rand(r)/(onCore1Rand(r) + onCore2Rand(r));
end



ratDifRand = targRatRand - shaftRatRand;

sortRatDifRand = sort(ratDifRand,'ascend');
mean(sortRatDifRand)
ci95 = [sortRatDifRand(round(reps*.025)) sortRatDifRand(round(reps * .975))]
P = mean(sortRatDifRand < ratDif)

scDensRes
scDensResRand = motDensityShellRand./motDensityCoreRand;

(mean(onShell1Rand)/isShell) / (mean(onCore1Rand)/isCore)

sortRatDifRand = sort(scDensResRand,'ascend');
mean(sortRatDifRand)
ci95 = [sortRatDifRand(round(reps*.025)) sortRatDifRand(round(reps * .975))]
P = mean(sortRatDifRand > scDensRes)


%%number on axon


onAx1
onAx1RandRand = sort(onAx1Rand,'ascend');
mean(onAx1RandRand)
ci95 = [onAx1RandRand(round(reps*.025)) onAx1RandRand(round(reps * .975))]
P = mean(onAx1RandRand >= onAx1)

axRat
onAx1RandRand = sort(axRatRand,'ascend');
mean(onAx1RandRand)
ci95 = [onAx1RandRand(round(reps*.025)) onAx1RandRand(round(reps * .975))]
P = mean(onAx1RandRand >= axRat)



(onShaft1 + onTarg1)/(onShaft1 + onTarg1 + onShaft2 + onTarg2)
onAx1/(onAx1+onAx2)
onTarg1 = sum(typeForMot1==2)
onAx1 = sum(typeForMot1==3)
onShaft2 = sum(typeForMot2==1)
onTarg2 = sum(typeForMot2==2)
onAx2 = sum(typeForMot2==3)
a = zeros((onShaft1 + onTarg1 + onShaft2 + onTarg2),1);
b = zeros((onAx1+onAx2),1);
a(1:(onShaft1 + onTarg1)) = 1;
b(1:onAx1) = 1;
ranksum(a,b)










