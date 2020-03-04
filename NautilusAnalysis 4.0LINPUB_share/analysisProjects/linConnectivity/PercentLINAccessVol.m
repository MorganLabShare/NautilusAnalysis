
%{
load('D:\LGNs1\Analysis\sm.mat')

%}


volBoundsRaw = [1049, 3458, 272; 601, 24514, 272;24985, 24514, 272;25689, 514, 272;...
2201, 6210, 9713; 26329, 4034, 9713; 793, 27970, 9713;25049, 27394, 9713]
volBounds = volBoundsRaw(:,[2 1 3]);

volBounds  = volBounds .* repmat([.024 .016 .030], [size(volBounds,1) 1]);
volRange = [min(volBounds,[],1); max(volBounds,[],1)];

vSize = [800 500 300];
umInd = find(ones(vSize(1),viSize(2),vSize(3)));
[y x z] = ind2sub(vSize,umInd);

useUm = (y >= volRange(1,1)) & (y <= volRange(2,1)) &...
    (x >= volRange(1,2)) & (x <= volRange(2,2)) &...
    (z >= volRange(1,3)) & (z <= volRange(2,3));

y = y(useUm); x = x(useUm); z = z(useUm);


skelPos = sm.skelPos;
skelInd = sub2ind(vSize,skelPos(:,1),skelPos(:,2),skelPos(:,3));
skelVol = zeros(vSize);
skelVol(skelInd) = 1;
