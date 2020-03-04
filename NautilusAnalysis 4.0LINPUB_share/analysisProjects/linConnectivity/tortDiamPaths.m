





%load('D:\LGNs1\Analysis\sm.mat')


edges = sm.skelEdges;
pos = sm.skelPos;
tort = sm.tortuosity;
diam = sm.minWidth';
paths = sm.paths.manPaths;

clf
scatter3(pos(tort>0,1),pos(tort>0,2),pos(tort>0,3),'g','.')
hold on
scatter3(pos(tort==0,1),pos(tort==0,2),pos(tort==0,3),'r','.')
hold off
set(gca,'clipping','off')

useVal = (tort>0) & (diam>0);

useTarg = find(sm.isTarg & useVal);
useAx = find(sm.isAx & useVal);
useShaft = find(sm.isShaft & useVal);
useAll = find(useVal);


%%
clear L pL pTort pDiam pTarg pShaft pAx pVar source
p = 0;
for np = 1:length(paths)
    
    path = paths{np};
    usePath = intersect(useAll,path);
    
    if length(usePath)>2
        p = p+1;
        source(p) = np;
        L(p) = length(path);
        pL(p) = length(usePath);
        pTort(p) = mean(tort(usePath));
        pDiam(p) = mean(diam(usePath));
        pTarg(p) = sum(sm.isTarg(path));
        pShaft(p) = sum(sm.isShaft(path));
        pAx(p) = sum(sm.isAx(path));
        pVar(p) = var(diam(usePath));
    end
end

usePath = L>0;
isShaftPath =   find(((pShaft./L)>.9) & usePath);
isTargPath = find(((pTarg./L)>.9) & usePath);


clf
hold on
for p = 1:length(isShaftPath)
    path = paths{isShaftPath(p)};
    scatter3(pos(path,1),pos(path,2),pos(path,3),'b','.')
end

for p = 1:length(isTargPath)
    path = paths{isTargPath(p)};
    scatter3(pos(path,1),pos(path,2),pos(path,3),'g','.')
end


%%
clf
hold on
scatter(pTort(isShaftPath),pDiam(isShaftPath),'o','b','filled')
scatter(pTort(isTargPath),pDiam(isTargPath),'o','g','filled')
hold off

%%

clf
hold on
scatter3(pTort(isShaftPath),pDiam(isShaftPath),pVar(isShaftPath),'o','b','filled')
scatter3(pTort(isTargPath),pDiam(isTargPath),pVar(isTargPath),'o','g','filled')
hold off


%%
clf
nTort = (pTort-mean(pTort))/std(pTort) * 1;
nDiam = (pDiam-mean(pDiam))/std(pDiam) * 1;
nVar = (pVar-mean(pVar))/std(pVar) * 1;
% 
% nTort = (pTort-mean(pTort))/std(pTort);
% nDiam = (pDiam-mean(pDiam))/std(pDiam);
% nVar = (pVar-mean(pVar))/std(pVar);

%combo = nTort;% + nDiam + nVar;
%combo = nVar;% + nDiam + nVar;

%combo = nDiam;% + nDiam + nVar;
combo = nTort + nVar - nDiam;
%combo = nTort  - nDiam;

[sortCombo idxComb] = sort(combo,'descend');
[sortTort idxTort] = sort(nTort,'descend');
[sortDiam idxDiam] = sort(nDiam,'descend');
[sortVar idxVar] = sort(nVar,'descend');

source(86)

combRange = [-5 : 1 : 5];
hCombTarg = hist(combo(isTargPath),combRange);
hCombShaft = hist(combo(isShaftPath),combRange);
hCombAll = hist(combo,combRange);

length(isTargPath)
length(isShaftPath)

clf
bar(combRange,hCombAll)
bar(combRange,[hCombShaft/sum(hCombShaft); hCombTarg/sum(hCombTarg)]',1)

val = pTort;
mean(val(isTargPath))
std(val(isTargPath))/sqrt(length(isTargPath))

val = pTort;
mean(val(isShaftPath))
std(val(isShaftPath))/sqrt(length(isShaftPath))

ranksum(val(isShaftPath),val(isTargPath))

%%
clf
hold on
scatter3(nTort(isTargPath),nDiam(isTargPath),nVar(isTargPath),'o','g','filled')
scatter3(nTort(isShaftPath),nDiam(isShaftPath),nVar(isShaftPath),'o','b','filled')
xlim([-2 2])
ylim([-2 2])
zlim([-2 2])

ranksum(combo(isTargPath),combo(isShaftPath))

%%
clf
bar(combRange,hCombAll)
bar(combRange,[hCombShaft; hCombTarg]')
bar(combRange,[hCombShaft/sum(hCombShaft); hCombTarg/sum(hCombTarg)]')









