function[dSub] = subDilate(sub)

subSize = size(sub,1);
nSub = zeros(subSize, 3);
c = 1;
shift = [-1 0 0; 1 0 0; 0 -1 0; 0 1 0; 0 0 -1; 0 0 1];
for s = 1:size(shift,1)
    nSub(c:c+subSize-1,:) = sub + repmat(shift(s,:), [subSize 1]);
    c = c+subSize;
end
allSub = cat(1,nSub,sub);
subBound = max(allSub,[],1);
sInd = sub2ind(subBound,allSub(:,1),allSub(:,2),allSub(:,3));
uInd = unique(sInd);
[y x z] = ind2sub(subBound,uInd);
dSub = cat(2,y, x, z);

