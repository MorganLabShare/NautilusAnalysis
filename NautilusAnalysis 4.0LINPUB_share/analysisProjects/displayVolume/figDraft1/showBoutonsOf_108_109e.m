

%% Load data
load('MPN.mat')
if ~exist('MPN','var')
    MPN = GetMyDir
end

synDir = ['D:\LGNs1\Analysis\seedBouton\seedBoutons14\'];
if ~(exist(synDir,'dir')),mkdir(synDir); end

if ~exist('obI','var') | ~exist('dsObj','var')
    disp('loading')
    load([MPN 'obI.mat'])
    load([MPN 'dsObj.mat'])
end

disp('showing')



colMap = hsv(256);
colMap = cat(1,[0 0 0],colMap);

%% Set Variables
seedCells = [108];
%seedCells = [201];



    clear viewProps
    
    viewProps.dim =1;
    targCells = [108 109];
    useList = obI2cellList_seedInput(obI,targCells);
    
    
    
    %% Find connectivity
    conTo = makeConTo(obI,targCells);
    useCells = intersect(conTo(1).rgcList, conTo(2).rgcList);
    useCells = useCells(1) ; % 1 = very good, 3 = ok, 9 very good

    
    
%%Reference lists
showCell = [108 109 useCells];
col = cat(1,[1 0 0 ; .1 .1 1],repmat([0 1 0],[length(useCells) 1]));
showCellNames = cat(2,num2cell(showCell));
    
    %% pick cells
    
  
    
    %% Pick synapses
    prePop{1} = [useCells];
    postPop{1} =  [targCells];
    
    %
    % prePop{3} = [];
    % postPop{3} =  [];
    %
    % prePop{1} = [];
    % postPop{1} =  [];
    
    
    cellPicDir = [MPN '\cellPic\'];
    if ~exist(cellPicDir,'dir'), mkdir(cellPicDir), end
    
    cellList = obI.cell.name;
    
    
    
    
    fsize = double(max(cat(1,dsObj.subs),[],1));
    minVal = double(min(cat(1,dsObj.subs),[],1));
    viewProps.viewWindow = [minVal; fsize];
    %}
  
    
    %% Display Variables
    
    viewProps.maxScaleFactor = .1;
    viewProps.sumScaleFactor = 3;
    viewProps.viewWindow = double([1 1 1; fsize]);
    viewProps.obI = obI;
    viewProps.dsObj = dsObj;
    viewProps.col = col;
    viewProps.fsize = fsize;
    viewProps.cellId = showCellNames;
    
    
    
    %% Display Cells
    
    I_topSum = showCellsAndMore(viewProps);
    image(uint8(I_topSum*1)), pause(.01)
    imwrite(uint8(I_topSum),[synDir '108_109_1006.png'])
    
    %% Draw boutons
    
    showCellNames = cat(2,num2cell(showCell));

    viewProps.cellId = num2cell(useCells);
    
    
%     col2 = colMap(ceil((1:length(viewProps.cellId))*256/length(viewProps.cellId)),:);
%     col2 = col2(randperm(size(col2,1)),:);
%     col2 = [1 0 0; 0 1 1; 0 1 1; 0 1 1];
    viewProps.col = repmat([0 1 0],[length(useCells) 1]);
    
    I_axons = showCellsAndMore(viewProps);
    image(uint8(I_axons))
    
    %% Ball
    ballRad = 16;
    ball = ones(ballRad*2+1,ballRad*2+1,ballRad*2+1);
    [y x z] = ind2sub(size(ball),find(ball));
    dists = sqrt((y-mean(y)).^2+(x-mean(x)).^2+ (z-mean(z)).^2);
    ball(:) = dists;
    ball(ball>ballRad) = 0;
    ballSum = sum(ball>0,3);
    ballSum = ballSum * 200/max(ballSum(:));
    [y x z ] =ind2sub(size(ball),find(ball>0));
    ballSub = [y x z] - ballRad - 1;
    
    
    dSamp =  (obI.em.res .* [4 4 1])./1000./obI.em.dsRes;

    anchors = double(obI.colStruc.anchors);
    anchors(:,1) = anchors(:,1)*dSamp(1);
    anchors(:,2) = anchors(:,2)*dSamp(2);
    anchors(:,3) = anchors(:,3)*dSamp(3);
    anchors = round(anchors);
    anchors(anchors<1) = 1;
    synapses = obI.nameProps.edges(:,1:3);
    
    
    dim = viewProps.dim;
    if dim == 1
        dims = [3 2];
    elseif dim == 2
        dims = [3 1];
    elseif dim == 3
        dims = [1 2];
    end
    
    showSyn  = I_topSum *0;
    
    usePre = [];
    for i = 1:length(prePop{1})
        usePre = cat(1,usePre,find(synapses(:,2)== prePop{1}(i)));
    end
    
    usePost = [];
    for i = 1:length(postPop{1})
        usePost = cat(1,usePost,find(synapses(:,1)== postPop{1}(i)));
    end
    
    foundSyn = intersect(usePre,usePost);
    
    useSynID = synapses(foundSyn,3);
    useAnchors = anchors(useSynID,:);
    
    dilateAnchors = zeros(size(useAnchors,1)*size(ballSub,1),3);
    S = size(ballSub,1);
    for a = 1:size(useAnchors,1)
        L = (a-1) * S;
        dilateAnchors(L+1:L+S,1) = ballSub(:,1) + useAnchors(a,1);
        dilateAnchors(L+1:L+S,2) = ballSub(:,2) + useAnchors(a,2);
        dilateAnchors(L+1:L+S,3) = ballSub(:,3) + useAnchors(a,3);
    end
    
    %%Get unique
    dilateAnchors(dilateAnchors<1) = 1;
    maxD = max(dilateAnchors,[],1);
    DAind = sub2ind(maxD,dilateAnchors(:,1),dilateAnchors(:,2),dilateAnchors(:,3));
    uDAind = unique(DAind);
    [y x z] = ind2sub(maxD,uDAind);
    dilateAnchors = [y x z];
    
    viewProps.mask = dilateAnchors;
    
    
    
    I_boutons = showCellsAndMore(viewProps);
    image(uint8(I_boutons)),pause(.01)
    
    %%
    I_pre = I_boutons;
    maskSyn = repmat(sum(I_pre,3),[1 1 3]);
    showSyn = I_pre;
    
    I_tweak = 255 * (I_topSum/max(I_topSum(:))).^.5;
    I_tweak = I_tweak * 1.5; %100/median(I_tweak(I_tweak>0));
    image(uint8(I_tweak))
    
    showSyn(~maskSyn) = (I_tweak(~maskSyn))* 1;
    %showSyn = I_topSum*.1;
    
    image(uint8(showSyn))
    
    % rotSyn = imrotate(showSyn,pi);
    % image(uint8(rotSyn))
    
    
    I_pre = I_axons;
    maskSyn = repmat(sum(I_pre,3),[1 1 3]);
    combPrePost = I_pre* .5 + I_boutons;
    combPrePost(~maskSyn) = ((I_topSum(~maskSyn))>0) * 75;
    image(uint8(combPrePost))
    
    
    
    
    %% Figure images
    if 0
        
        
        SE = strel('disk',0);
        
        
        showSyn2 = imdilate(showSyn,SE);
        I_axons2 = imdilate(I_axons,SE);
        I_topSum2 = imdilate(I_topSum,SE);
        combPrePost2 = imdilate(combPrePost,SE);
        
        image(uint8(I_axons2))
        
        
        showSyn2 = cropI(showSyn2);
        I_axons2 = cropI(I_axons2);
        I_topSum2 = cropI(I_topSum2);
        combPrePost2 = cropI(combPrePost2);
        
        
        imwrite(uint8(showSyn2),sprintf('%sboutons%d.png',synDir,targCells))
        imwrite(uint8(I_axons2),sprintf('%saxons%d.png',synDir,targCells))
        imwrite(uint8(I_topSum2),sprintf('%stargCell%d.png',synDir,targCells))
        imwrite(uint8(combPrePost2),sprintf('%scombPrePost%d.png',synDir,targCells))
        
    end
    %}
    
    %{
cropSyn = showSyn;
[y x] = find(sum(cropSyn,3)>0);
cropSyn = cropSyn(min(y):max(y),min(x):max(x),:);
image(uint8(cropSyn * 1)),pause(.01)
    %}
    
    %{
imwrite(uint8(showSyn),sprintf('%ssynPos_%s.png',synDir,'108cladeBouton'))

imwrite(uint8(showSyn),sprintf('%ssynPos_%06.0f.png',synDir,[ 0 ]))


imwrite(uint8(cropSyn),sprintf('%ssynPosNoSyn_%06.0f.png',synDir,showCell))

    %}
    
