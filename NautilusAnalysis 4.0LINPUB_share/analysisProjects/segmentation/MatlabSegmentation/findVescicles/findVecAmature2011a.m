colormap gray(256)

[TFN TPN] =  GetMyFile('.tif')


Iraw = imread([TPN TFN]);
%I = Iraw(200:750,1:350);
I = Iraw;
subplot(2,2,1)
image(I)

I = 255-I;



Im = medfilt2(double(I), [3 3]);

[ys, xs] = size(I);

%% Create hollow gaussian with negative surround

R = 50;

fsize = R * 2 + 1;
distMap = zeros(fsize,fsize);
for x = 1:fsize,
    for y = 1:fsize
        distMap(y,x) = sqrt((y-R-1)^2 + (x-R-1)^2);
    end
end
useK = find(distMap<=R);
blankK = find(distMap>R);
% 
% memA = 10
% memSD = 5
% memK = memA * exp(-.5 * ((distMap)/memSD)^2);
% memK(useK) = memK(useK)-mean(memK(useK));
% memK = memK /max(memK(:));
% memK(blankK) = 0;
% image(memK*100+100)


centA = 10
centSD = 20
center = centA * exp(-.5 * ((distMap)/centSD)^2);
center = center /max(center(:))* 1.7;
%center(center > mean([mean(center(:)) max(center(:))])) = mean(center(:));

surA = 1
surSD = 30;
surround = surA * exp(-.5 * ((distMap)/surSD)^2);
surround = surround/max(surround(:))*2;

sur2A = 1
sur2SD = 50;
surround2 = sur2A * exp(-.5 * ((distMap)/sur2SD)^2);
surround2 = surround2/max(surround2(:))*.4;

kRat = mean(center(useK))/mean(surround(useK));
kern =  surround - surround2 - center;
mean(kern(:))
kern(useK) = kern(useK)-mean(kern(useK));
kern(blankK) = 0;

%%Ring kern
ring = distMap*0;
r = [3 ,5,20];
ring(distMap<r(3)) = -1;
ring(distMap<r(2)) = 1;
ring(distMap<r(1)) = -1;
ring(ring>0)=ring(ring>0)/sum(ring(ring>0));
ring(ring<0)=ring(ring<0)/abs(sum(ring(ring<0)));
kern = ring;




%image(kern * 155/max(kern(:)) + 100 )
subplot(2,2,2)
plot(kern(R+1,:))
%ylim([-1 2])


%% Convolve
subplot(2,2,3)
Imf = fastCon(Im,kern);

sdI = std(Imf(:)); 
Imf = Imf - mean(Imf(:));
Imf = Imf * 50/sdI;
Imf = Imf + 120;
image(Imf)
pause
%% Threshold

It = Imf > (median(Imf(:)) * 1.5);
image(It*1000);

Il = bwlabel(It,4);

Ivec = It * 0; 
Ilarge = Ivec;
vPos = [];
Icent = It * 0;
Ilong = It * 0;
Ismall = It * 0;
for i = 1: max(Il(:))
    lPos = find(Il == i);
    if length(lPos)>200
        Ilarge(lPos) = 1;
    elseif length(lPos)<20
        Ismall(lPos) = 1;
    else
        [y x ] = ind2sub([ys xs],lPos);
        [a pc c d] = princomp([y x]);
        lengthWidth = max(pc,[],1) - min(pc,[],1);
        if lengthWidth(1)/lengthWidth(2) > 2;
            Ilong(lPos) = 1;
        else
            
            Ivec(lPos) = 1;
            [y x] = ind2sub([ys xs],lPos);
            vPos(size(vPos,1)+1,:) = [mean(y) mean(x)];
            Icent(round(mean(y)), round(mean(x))) = 1;
        end    
    end
end

image(Icent * 10000)
Imem = Ilarge | Ilong;

%% group

R = 20;

fsize = R * 2 + 1;
distMap = zeros(fsize,fsize);
for x = 1:fsize,
    for y = 1:fsize
        distMap(y,x) = sqrt((y-R-1)^2 + (x-R-1)^2);
    end
end
useK = find(distMap<=R);
blankK = find(distMap>R);

% groupA = R^2
% groupSD = R
% groupK = groupA * exp(-.5 * ((distMap)/groupSD)^2);
% groupK = groupK - groupK(1,R+1);

groupK = R - distMap;
groupK(groupK<0) = 0;
groupK = groupK/max(groupK(:));

Igroup = conv2(Icent, groupK,'same');
Igroup(Igroup < .6) = 0;
Igroup(Ilarge>0) = 0;

SE = strel('disk', 5);
Iopen = imopen(Igroup,SE);
Iopen(Ilarge>0) = 0;

[IgLab IglN] = bwlabel(Iopen,4);

Ipass = Igroup * 0;
for i = 1: IglN
   groupPos = find(IgLab == i);
%    gVal(i) = sum(Igroup(groupPos));
   if length(groupPos) > 1000
       numVec(i) = sum(Icent(groupPos));
       Ipass(groupPos) = 50 + numVec(i)* 5;
   end
   
end

image(Ipass * 1000)


image(Igroup* 100/mean(Igroup(:)))

% 
% SE = strel('disk',15);
% Igroup = imfilter(Ivec,fspecial('disk',20));
% 
% Iclose = imclose(Ivec,SE);
% Iclose(Ilarge>0) = 0;
% Iclust = Iclose * 0;
% 
% 
% 
% [Icl gN] = bwlabel(Iclose,4);
% for i = 1: gN
%    groupPos = find(Icl == i);
%    if length(groupPos) > 1000
%        vecAr = sum(Ivec(groupPos));
%        if vecAr/length(groupPos) > .3
%             Iclust(groupPos) = 1;
%        end
%    end
%     
% end



%% Show
Ic = Ipass;
Ic(:,:,2) = I;
Ic(:,:,3) = (Ivec * 1000);

image(uint8(Ic))
imwrite(I,[TPN 'sample.tif'],'compression','none')
imwrite(uint8(Ic),[TPN 'found.tif'],'compression','none')
