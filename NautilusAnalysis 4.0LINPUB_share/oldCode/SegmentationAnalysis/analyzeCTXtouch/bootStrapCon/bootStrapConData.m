
%clear all
%generic connectivity skew test
%-joshm
tic
%% options
reps = 100000;
forcePercent = .1

%% make dummy data until someone gives me real data
% preIn = fix(rand(100,1)*90) + 1;
% postIn = fix(rand(100,1)*3)+1;

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

postSites = hist(post,[.5:1:max(post)-.5]);
postDist = postSites/synNum;
hitNum = hist(pre,[.5:1:max(pre)-.5]);
preDist = hitNum/synNum;


multAx = find(hitNum>1); %Only measure multiples

%% Force targeting to strength of sample
for i = 1 : fix(forcePercent * length(multAx))
   post(pre == multAx(i)) = fix(rand * postNum)+1;
end
    
%% get ax positions
for a = 1:preNum;
    axPos{a} = find(pre == a);
end

%% measure observed
observedDifs = zeros(length(multAx),1);
    for a = 1:length(multAx)
        ax = multAx(a); %get multi axon
        hitPost = post(axPos{ax}); %retrieve post partners for 
        aHist = hist(hitPost,[.5:1:(postNum-.5)]);
        if max(aHist)>1 % if multiple innervation
            dDif =  aHist - postDist * hitNum(ax);
            difD= max(dDif); %pick your hypothesis
        else
            difD = 0;
        end
        
        observedDifs(a) = difD
    end
subplot(2,1,1)
hist(observedDifs)
obSkew = mean(observedDifs);

%% run

aveSkew = zeros(reps,1);
difs = zeros(length(multAx),1);
for i = 1:reps
    %%Scramble posts
    pos = rand(synNum,1);
    [a newPos] = sort(pos);
    newDend = post(newPos);
    
    for a = 1:length(multAx)
        ax = multAx(a);
        hitPost = newDend(axPos{ax});
        aHist = hist(hitPost,[.5:1:(postNum-.5)]);
        if max(aHist)>1 % if multiple innervation
            dDif =  aHist - postDist * hitNum(ax);
            difD= max(dDif); %pick your hypothesis
        else
            difD = 0;
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


toc
