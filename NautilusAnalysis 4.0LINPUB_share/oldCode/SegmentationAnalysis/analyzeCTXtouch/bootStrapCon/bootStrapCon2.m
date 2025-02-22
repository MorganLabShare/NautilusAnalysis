

%generic connectivity skew test
%-joshm

%% options
reps = 10000;

%% make dummy data until someone gives me real data
preIn = fix(rand(100,1)*90) + 1;
postIn = fix(rand(100,1)*3)+1;

%% renumber IDs
ids = sort(unique(preIn));
newIds = 1:length(ids);
lookupIds(ids) = newIds;
pre = lookupIds(preIn);

ids = sort(unique(postIn));
newIds = 1:length(ids);
lookupIds(ids) = newIds;
post = lookupIds(postIn);


%% get data info
preNum = length(unique(pre));
postNum = length(unique(post));
synNum = length(pre);

postSites = hist(post,postNum);
postDist = postSites/synNum;
hitNum = hist(pre,preNum);
preDist = hitNum/synNum;


%% get ax positions
for a = 1:preNum;
    axPos{a} = find(pre == a);
end

%% measure observed
    for a = 1:preNum
        hitPost = post(axPos{a});
        difD = 0;
        if hitNum(a)>1  %if more than one contact
            aHist = hist(hitPost,[.5:1:(postNum-.5)]);
            if max(aHist)>1 % if multiple innervation
                dDif =  aHist - postDist * hitNum(a);
                difD= max(dDif); %pick your hypothesis
            end
        end
       
        observedDifs(a) = difD;
    end
    subplot(2,1,1)
hist(observedDifs)
obSkew = mean(observedDifs);

%% run 
multAx = find(hitNum>1);
for i = 1:reps
    %%Scramble posts
    pos = rand(synNum,1);
    [a newPos] = sort(pos);
    newDend = post(newPos);
    
    for a = 1:preNum
        hitPost = newDend(axPos{a});
        difD = 0;
        if hitNum(a)>1  %if more than one contact
            aHist = hist(hitPost,[.5:1:(postNum-.5)]);
            if max(aHist)>1 % if multiple innervation
                dDif =  aHist - postDist * hitNum(a);
                difD= max(dDif); %pick your hypothesis
            end
        end
       
        difs(a) = difD;
    end
    aveSkew(i) = mean(difs);
    
    if mod(i,1000) == 0
        sprintf('running %d of %d reps',i,reps)
    end
end

%% Analyze Results
skewBins = [min(aveSkew):(max(aveSkew)-min(aveSkew))/100:max(aveSkew)];
subplot(2,1,2)
hist(aveSkew,skewBins);

P = mean(aveSkew > obSkew)



