

load('MPN.mat')
load([MPN 'obI.mat'])
%load([MPN 'dsObj.mat'])
load('D:\LGNs1\Analysis\sm.mat')


postClass = sm.postClass(sm.pre == 125);
preClass = sm.preClass(sm.post == 125);


allIn = length(preClass)
rgcIn = sum(preClass == 1)    
linIn = sum(preClass == 3)    
unkIn = sum(preClass == 4) 
nonIn = sum(preClass == 0)
allOut = length(postClass)
tcOut = sum(postClass == 2)    
linOut = sum(postClass == 3)    
unkOut = sum(postClass == 4)  
nonOut = sum(postClass == 0)


%% Find the zeros

badPre = find(( sm.preClass == 0) & ( sm.post == 125))   
badPost = find(( sm.postClass == 0) & ( sm.pre == 125))
badPrePos = sm.pos(badPre,[1 2 3]);
reSamp = obI.em.res .* [4 4 1]
badPreVox = (badPrePos * 1000) ./ repmat(reSamp,[size(badPrePos,1) 1]);
badPreVox = badPreVox(:,[2 1 3]);


badPostPos = sm.pos(badPost,[1 2 3]);
badPostVox = (badPostPos * 1000) ./ repmat(reSamp,[size(badPostPos,1) 1]);
badPostVox = badPostVox(:,[2 1 3]);


badPreID = sm.pre(badPre)
badPostID = sm.post(badPost)

disp(sprintf('%.0f %.0f %.0f',badPreVox(1,:)))
    
bt = badPre(1);

find((sm.pre == 10020) & ( sm.post == 125))


%% show bad

showBad = badPre(1,:);
badPos = sm.pos(showBad,:);
pre125 = find(sm.post==125);
showGood = setdiff(pre125,[badPre; badPost])
goodType = sm.preClass(showGood);
goodPos = sm.pos(showGood,:);
goodRGC = find(goodType == 1);
goodTC = find(goodType == 2);
goodLIN = find(goodType == 3);
goodUNK = find(goodType == 4);



scatter3(badPos(1),badPos(2),badPos(3),'.','r')
hold on
scatter3(goodPos(goodRGC,1),goodPos(goodRGC,2),goodPos(goodRGC,3),'.','g')

hold off

xlim([badPos(1)-10 badPos(1)+10])
ylim([badPos(2)-10 badPos(2)+10])
zlim([badPos(3)-10 badPos(3)+10])

    
    
    
    

