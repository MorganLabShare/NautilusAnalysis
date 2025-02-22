function[lI] = segEWA(I);
%% Matlab 2d segmentor 
%%-Josh Morgan


%% Variables

%%Edge varibles
gKern1 = gaus3d([5 5 1],2); %kernal for edge convolution
threshs= [.7];%[.8:.1:.8]; % df = [.3:.1:.5], thresolds to check for edges.  later scaled
sizes = 1:1:5;  % sizes to check for edges

%%Watershed variables
gKern2 = gaus3d([15 15 1],2); %df = ([ 20 20 1], 3)
watMin = 30; %df = 10, minimum intensity change for watershed

%%Trim Watershed variables
searchRadius = 30; %df = 20

%% Read Data
colormap gray(256)
tic
%I = I(500:1000,500:1000);
[ys, xs] = size(I);

I3 = cat(3,I,I,I); %Color image

subplot(1,2,1)
image(I)
subplot(1,2,2)

%% Edge
subplot(1,2,2)

c1 = fastCon(I,gKern1);
%image(fitH(c1))
eI = sumEdge(c1,threshs,sizes,0); % robustish edge detection
image(fitH(c1)*.5 + eI*1000)
pause(.01)
%%Filter Edges
subplot(1,2,2)
eI = bwlabel(eI,8);
eProps = regionprops(eI,'MinorAxisLength','MajorAxisLength');
minAx = [eProps.MinorAxisLength];
majAx = [eProps.MajorAxisLength];

use = (majAx > 50);
use = [0 use];
uI = use(eI + 1);

image(fitH(c1)*.5 + uI*1000)
pause(.01)

%% Watershed sum Edges
%{
%theres got to be a use for this
subplot(1,2,1);

%%Low pass to find wells
dI1 = fastCon(eI,gaus3d([6 6 1],1));%dI1 = imhmin(dI,.04);
%dI1 = imhmin(dI1,.000005);
image(fitH(dI1)),pause(.01)

wI = watershed(dI1,8);
wProps = regionProps(wI,I,'PixelIdxList','MeanIntensity');
mi = [0 wProps.MeanIntensity];
image(fitH(mi(wI+1))),pause(.01)

%% Sort Wat1 

subplot(1,2,2)
[wy wx] = find(wI==0);
near = [-1 0; 1 0; 0 -1; 0 1; -1 -1; -1 1; 1 1; 1 -1];
allCon = zeros(length(wy) * 3,2);
c = 0;
for i = 1: length(wy)
    nyx = wall([wy(i) + near(:,1) wx(i) + near(:,2)],size(I));
    cons = unique(wI(sub2ind(size(wI),nyx(:,1),nyx(:,2))));
    cons = cons(cons>0);
    conp = combntns(cons,2);
    allCon(c+1:c+size(conp,1),:) = conp;
    c = c + size(conp,1);
end
allCon = allCon(1:c,:);
allCon = unique(allCon,'rows');

fR = sort(unique(allCon));
%%
passReg = I * 0;
pass = zeros(length(fR)+1,1);
for i = 1: length(fR)
   [fy fx] = find(allCon == fR(i));
   rVal = wProps(fR(i)).MeanIntensity;
   surR = allCon(fy,:);
   surR = setdiff(surR(:),fR(i));
   sVal = [wProps(surR).MeanIntensity]; 
   pass(i+1) = ( rVal - min(sVal)) > (max(sVal)-rVal);
   %pass(i+1) = (sum(sVal>rVal)/length(sVal))>=.5;
end

image(pass(wI+1)*50)
blankW = pass(wI + 1);

%% Watershed Dark
subplot(1,1,1)
gKern2 = gaus3d([20 20 1],1);
c2 = fastCon(I,gKern2);

image(fitH(c2))
c2 = c2;
image(fitH(c2))
minC2 = imhmin(c2,10);

wI2 = watershed(minC2,8);
image((wI2==0)*1000 + c2 * .8);
pause(.01)

%w2Props = regionProps(wI2,I,'MeanIntensity');
%}
%% Watershed
subplot(1,2,2)

c2 = fastCon(I,gKern2);

image(fitH(c2))
c2 = max(c2(:)) - c2;
image(fitH(c2))
minC2 = imhmin(c2,watMin);

wI2 = watershed(minC2,8);
image((wI2==0)*1000 + c2 * .8);
pause(.01)

%w2Props = regionProps(wI2,I,'MeanIntensity');
%}

%% Trim Water2


[wy wx] = find(wI2==0);
sRad = searchRadius;

kSize = sRad * 2+1;
dKern = zeros(kSize);
[y x] = ind2sub(size(dKern),find(dKern==0));
dKern(:) = sqrt(((y-sRad-1)).^2 + ((x - sRad -1)).^2);

sur = sRad - dKern;
mid = sur>=sur(sRad,sRad-2);
sur = (sur>=sur(sRad,1)) & sur<sur(sRad,3);
[y x ] = find(mid);
myx = [y x] - sRad-1;
[y x] = find(sur);
yx = [y x] - sRad-1;
[y x] = find(dKern<=sRad);
dList = dKern(dKern<=sRad);
nyx = [y x] - sRad -1;
newBorders = double(I * 0);
for i = 1:length(wy)
    %retrieve 6 closest edges
    dy = wy(i) + nyx(:,1);
    dx = wx(i) + nyx(:,2);
    dyx = wall([dy dx],size(I));
    sInd = sub2ind(size(I),dyx(:,1),dyx(:,2));
    sEdge = uI(sInd);
    dVal = dList(sEdge>0); %Grab distances
    if ~isempty(dVal) %if there are edges
        
    [dVal idx] = sort(dVal);
    nidix = idx(dVal <= dVal(min(6,length(dVal))));
    sVal = c2(sInd); %get brightness
    eVal = sVal(sEdge>0); %get edge brightness
    useVal = eVal(nidix);
    
%     
%     dy = wy(i) + yx(:,1);
%     dx = wx(i) + yx(:,2);
%     dyx = wall([dy dx],size(I));
%     sInd = sub2ind(size(I),dyx(:,1),dyx(:,2));
%     sVal = c2(sInd);
%     sEdge = uI(sInd);
%     eVal = sVal(sEdge>0);
%     eVal = sVal;
    
    
    %Get middle values
    dy = wy(i) + myx(:,1);
    dx = wx(i) + myx(:,2);
    dyx = wall([dy dx],size(I));
    mVal = c2(sub2ind(size(I),dyx(:,1),dyx(:,2)));
    
    
    %newBorders(wy(i),wx(i)) = max(mVal) - median(sVal);
    
        newBorders(wy(i),wx(i)) = median(mVal)-min(useVal);
    end
end
subplot(1,1,1)

%newBorders = fastCon(newBorders,gaus3d([5 5 1],3))>.5;
newBorders = imdilate(newBorders,strel('disk',3));
image(newBorders * 100)
%% Decide on final image

pI = newBorders;
%pI(blankW>0) = 0;

pause(.01)
%% Label
subplot(1,1,1)


pI(1:10,:) = 1;
pI(end -10:end,:) = 1;
pI(:,1:10) = 1;
pI(:,end-10:end) = 1;

lI = bwlabel(~pI,8);
subplot(2,2,1)
image(I)
subplot(2,2,2)
image(uint8(cat(3,wI2*1000,c2,uI*1000)))
subplot(2,2,3)
for i = 1:1
    myCol = hsv(max(lI(:))+1)*40;

    [r rix] = sort(rand(size(myCol,1)),1);
    myCol= myCol(rix,:);
    myCol = cat(1,[0 0 0],myCol);
    red = myCol(:,1); green = myCol(:,2); blue = myCol(:,3);
    skipCol = 5 + round(rand*10);

    colO = uint8(cat(3,red(lI+1),green(lI+1),blue(lI+1)));
    image(I3 * .7 + colO),pause(.01)
end
autoTime = toc
