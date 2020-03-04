function[subs ia ic] = uniqueSubs(subs)


maxSub = max(subs,[],1);
inds = sub2ind(maxSub,subs(:,1),subs(:,2),subs(:,3));
[uInd ia ic] = unique(inds);
subs = subs(ia,:);



