


%load('D:\LGNs1\Analysis\sm.mat')
%%

edges = sm.skelEdges;
pos = sm.skelPos;


tort = sm.tortuosity-1;
diam = sm.minWidth';

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
clf
scatter(tort(useTarg),diam(useTarg) +rand(length(useTarg),1)*.02,'.','g')
hold on

scatter(tort(useShaft),diam(useShaft) +rand(length(useShaft),1)*.02+.05,'.','b')
scatter(tort(useAx),diam(useAx) +rand(length(useAx),1)*.02+.1,'.','r')

hold off

%%

scatter(tort(useTarg),diam(useTarg) +rand(length(useTarg),1)*.02,'.','g')
hold on

%%
dRange = [0 : .02 : 3.5];
tRange = [0 : .02 : 1];
binned = zeros(length(dRange)-1, length(tRange)-1);
for d = 1:(length(dRange) -1)
    for t = 1 : (length(tRange) -1)
        binned(d,t) = sum((diam>=dRange(d)) & ( diam<dRange(d+1)) & ...
            (tort >= tRange(t)) & (tort < tRange(t+1)));
    end
end

bar3(binned)
image(binned)

%%

hTargTort = hist(tort(useTarg),tRange);
hShaftTort = hist(tort(useShaft),tRange);
hAxTort = hist(tort(useAx),tRange);
hAllTort = hist(tort(useAll),tRange);

hTargDiam = hist(diam(useTarg),dRange);
hShaftDiam  = hist(diam(useShaft),dRange);
hAxDiam  = hist(diam(useAx),dRange);
hAllDiam  = hist(diam(useAll),dRange);


bar(tRange,hAllTort)
hold on
bar(tRange,hTargTort)
bar(tRange,hShaftTort)
hold off

bar(tRange,[hShaftTort' hTargTort'])

bar(dRange,hAllDiam)
%% 
combo = tort(useAll)/var(tort(useAll)) .* diam(useAll)/var(diam(useAll))

cRange = [0 : .01:3]

hComboAll = hist(combo,cRange)

bar(cRange,hComboAll)





