function[cellList cellCols] = seedMarkov(MPN)

%%
%MPN = GetMyDir;
load([MPN 'obI.mat']);

seedList = [108 201 109 903 907];
useList = obI2cellList_seedInput_RGC_TCR(obI,seedList);
con = useList.con;
%%%

reps = 1000000000
countThresh = 100; %smallest number of paths allowed
%%%
preCount = zeros(size(con,1),1);
transPre= {};

for i = 1:size(con,1)
    transSub = [];
    for p = 1:size(con,2)
        if con(i,p)
            %pause
        
        transSub = [transSub ones(1,con(i,p))*(p+size(con,1))];
        end
    end
    transPre{i} = transSub;
    preCount(i) = length(transSub);
end


postCount = zeros(size(con,1),1);
transPost = {};
for p = 1:size(con,2)
    transSub = [];
    for i = 1:size(con,1)
        if con(i,p)
            %pause
        
        transSub = [transSub ones(1,con(i,p))*i];
        end
    end
    transPost{p} = transSub;
    postCount(p) = length(transSub);
end

cellList = cat(1,useList.preList',useList.postList');
trans = cat(1,transPre',transPost');
pCount = cat(1,preCount,postCount);

% 
% targ = find(cellList==108);
% cellList(trans{targ})

%%% 

num = length(cellList);
P = ceil(rand*num);

wasHit = zeros(1,num);
lastHit = zeros(1,num);
countHits = zeros(1,num);
trackHit = zeros(num);

numHit = zeros(num);
sumLength = zeros(num,1);

for r = 1:reps
    P = trans{P}(ceil(rand*pCount(P)));
    
    wasHit(P) = 1;
    lastHit = lastHit + 1;
    
    if sum(wasHit) == length(wasHit)
        countHits(P) = countHits(P) + 1; %record how many measurements are made for each cell
        trackHit(P,:) = trackHit(P,:) + lastHit; %record last time each P was passed
       
    end
    
    lastHit(P) = 0; %reset hit memory
    
    if ~mod(r,100000)
        
        image(trackHit./repmat(countHits,[num,1])*.1),pause(.01)
        minCount = min(countHits(:));
        disp(sprintf('min count is %d of %d after %d jumps',minCount,countThresh,r))
        if minCount>countThresh,break,end
    end
    
    
%     showCon = con;
%     showCon(I,:) = showCon(I,:) +5;
%     showCon(:,P) = showCon(:,P) + 5;
%     image(showCon*10),pause(.01)
%     recPass(I,P) = recPass(I,P) +1;
end



meanPath = trackHit./repmat(countHits,[num,1]);
image((256-meanPath)*.1)

%%

clear toSeed fromSeed
for s = 1:length(seedList)
    targ = find(cellList == seedList(s));
    toSeed(s,:) = meanPath(targ,:);
    fromSeed(s,:) = meanPath(:,targ)';
end

seedWalk(1,:) = fromSeed(1,:);i
seedWalk(2,:) = fromSeed(2,:);
%seedWalk(3,:) = fromSeed(4,:);
seedWalk(3,:) = min(fromSeed(3:5,:),[],1);


cellCols = seedWalk'
cellCols = cellCols / 10;%(std(cellCols(:)));
% for i = 1:3;
%     cellCols(:,i) = cellCols(:,i)/max(cellCols(:,i));
% end
cellCols = 1-cellCols;
cellCols(cellCols<0) = 0;
cellCols(cellCols>1) = 1;

scatter(cellCols(:,1),cellCols(:,2),'r');
hold on
scatter(cellCols(:,1),cellCols(:,3),'b');
hold off


scatter(cellCols(:,1),cellCols(:,2),'r');
hold on
scatter(cellCols(:,1),cellCols(:,3),'b');
hold off


scatter(fromSeed(1,:),fromSeed(2,:),'r');
hold on
scatter(fromSeed(1,:),fromSeed(3,:),'b');
hold off

image(permute(cellCols,[3 1 2]))

















