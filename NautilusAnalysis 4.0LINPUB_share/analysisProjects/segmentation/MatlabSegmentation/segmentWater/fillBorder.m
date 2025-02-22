clear all
TPN = GetMyDir;

% Inams = getPics([TPN]);
% if exist([TPN 'edited'])
%     labelDir = 'edited\';
% elseif exist([TPN 'labeled'])
%     labelDir = 'labeled\';
% else
%     sprintf('No labels found.')
% end

labelDir = 'fused2\';
inams = getPics([TPN labelDir]);  %find all tifs

if ~exist([TPN 'filled'])
    mkdir([TPN 'filled']);
end

for n = 1 : length(inams)
    sprintf('Running file %d of %d',n,length(inams))

Iraw = imread([TPN labelDir inams{n}]);

%% search Kernal
sRad = 1;
kSize = sRad * 2+1; 
dKern = zeros(kSize);
[y x] = ind2sub(size(dKern),find(dKern==0));
dKern(:) = sqrt(((y-sRad-1)).^2 + ((x - sRad -1)).^2);
[y x ] = find(dKern<=sRad);
my = y  - sRad-1;
mx = x - sRad -1;

%%pad
I = pad(Iraw + 1,sRad);
Ifill = I;

[ys xs] = size(I);
%%
for r = 1:16
[by bx] = find(I == 1);

showI = I * 0;
cmap = hsv(256);
cmap(1,:) = 0;
colormap(cmap);

for i = 1:length(by);
    dy = my + by(i) ;
    dx = mx + bx(i);
    sInd = dy + (dx-1) * xs;
    val = I(sInd);
    ids = val(val>1);
    if ~isempty(ids)
        id = mode(single(ids));
        Ifill(by(i),bx(i)) = id;        
    end
%     
%    
%      if ~mod(i,10000),
%          showI = mod(Ifill,254)+1;
%          showI(Ifill==1) = 0;
%          image(showI),
%          pause(.01),
%      end
end

I = Ifill;
if ~sum(I(:)==1)
    break
end
end


I = unpad(I,sRad)-1;

 showI = mod(I,254)+1;
         showI(I==1) = 0;
         image(showI),
         pause(.01),

imwrite(I,[TPN 'filled\' inams{1}]);
end
