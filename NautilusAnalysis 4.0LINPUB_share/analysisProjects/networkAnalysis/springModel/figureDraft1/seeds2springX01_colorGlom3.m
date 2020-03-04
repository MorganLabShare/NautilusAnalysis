



%% Get data
loadData = 1;
if loadData
    clear all
    load('MPN.mat')
    %MPN = GetMyDir;
    load([MPN 'obI.mat']);
    
    seedList = [ 108 201 903 907];
    %seedList = [ 108  201 109 ];
    
    useList = obI2cellList_seedInput_RGC_TCR(obI,seedList);
    %seedPref = seedPreferences(seedList,useList);
    allEdges = obI.nameProps.edges(:,[2 1]);
    
end

itag  = 'giant';

springDir = 'D:\LGNs1\Analysis\springDat\figDraft1b\';
springRes = 'D:\LGNs1\Analysis\springDat\results\';
if ~exist(springDir,'dir'), mkdir(springDir), end
if ~exist(springRes,'dir'), mkdir(springRes), end

load([springRes 'res_all_Phage_edit3.mat'])
load([springRes 'fourSeeds_edit1.mat'])


%% Filter for convergence

con = useList.con;
%allEdges = con2syn(con>0)

con2 = con;
if 0 %zero seeds
    for i = 1:length(seedList)
        con2(:,find(useList.postList == seedList(i))) = 0;
    end
end

minEdge = 1;
minSyn = 1;
minCon = 1;
binaryMat = 0;
con2(con2<minCon) = 0;


numIn = sum(con2>0,1);
synIn = sum(con2,1);
useIn = (numIn>=minEdge) & (synIn>=minSyn);

numOn = sum((con2>0).*repmat(useIn,[size(con2,1),1]),2);
synOn = sum((con2).*repmat(useIn,[size(con2,1),1]),2);
useOn = (numOn>=minEdge) & (synOn>=minSyn);

nodeIDs = [useList.preList(useOn) setdiff(useList.postList,seedList)];
nodeType = [useList.preList(useOn)*0+1 setdiff(useList.postList,seedList)*0+2];


nodeIDs = [useList.preList(useOn) (useList.postList(useIn))];
nodeType = [useList.preList(useOn)*0+1 (useList.postList(useIn))*0+2];



nodeNum = length(nodeIDs);
lookUpID(nodeIDs+1) = 1:length(nodeIDs);

%% Set color
nodeCol = zeros(nodeNum,3);

%%Set color according to attribute
if 0
    %[colorList cellCol] = getAttributes(obI);
    nodeCol = nodeCol + .2;
    
    load([MPN 'cb2d.mat'])
    colorList = cb2d.IDs;
    colPropRaw = cb2d.areaUM;
    
    [colorList colPropRaw] = getList_mtaCount();
    
    [colorList colPropRaw] = getList_giantBoutonsCounts(MPN);
    [colorList colPropRaw] = getList_inSpine;
    
    nodeProp = [];nodePropRef = [];
    for i = 1:length(nodeIDs)
        targ = find(colorList == nodeIDs(i));
        if ~isempty(targ)
            if length(targ)>1
                'too many targets'
                colorList(targ)
            end
            nodeProp= [nodeProp colPropRaw(targ(1))];
            nodePropRef = [nodePropRef i];
            
        end
    end
    
    propRange =[ 0 .75]
    showRange = round([propRange(1) : diff(propRange)/10 : propRange(2)]*10)/10
    ticPos = [0:10:100];
    
    colProp = nodeProp-propRange(1);
    colProp = ceil(colProp/((propRange(2)-propRange(1))) * 100);
    colProp(colProp<1) = 1;
    colProp(colProp>100) = 100;
    
    colTable = bluered(100);
    cellCol = colTable(colProp,:);
    
    %cellCol(nodeProp==0,:) = 0;
    
    nodeCol(nodePropRef,:) = cellCol;
    nodeType(nodePropRef) = nodeType(nodePropRef) + 2;
    
    
    
    
    
    cat(2,nodeIDs', nodeCol);
end

if 1
    %%
    nodeCol = nodeCol + .2;
    
    lookupCol = [1 0 0; 0 1 0; 1 0 1; 1 1 0; 0 1 1; 1 1 0];
    lookupCol = [ 0 .2 1 ; 1 .2 0 ; 0 1 0 ; 1 0 1 ; 1 1 0; 1 0 0]
    lookupCol = [ 0 1 0 ;  1 .2 0 ; 0 .2 1 ; 1 0 1 ; 1 1 0 ; 0 .2 1 ] *1;
    conTo = makeConTo(obI,201);

    useRGCs = [conTo.rgcList];

    glomList = getList_erosionGlom();
    for i = 1:length(glomList)
        
        %isGlom = glomList(glomList(:,2) == i,1);
        isGlom = glomList{i};
           isGlom = intersect(useRGCs,isGlom);

        for a = 1:length(isGlom);
            targ = find(nodeIDs == isGlom(a));
            if ~isempty(targ)
                
                nodeCol(targ,:) = lookupCol(i,:);
                if nodeType(targ)<=2
                    nodeType(targ) = nodeType(targ) + 2;
                end
            end
            
        end
    end
end




%%Set axons according to seed
if 0
    seedCol = [1 0 0; 0 1 0;  0 0 1; 0 .3 1; 0 .3 1] * .6;
    for s = 1:length(seedList)
        useCol = seedCol(s,:);
        for n = 1:nodeNum
            nodeCol(n,:) = nodeCol(n,:) + useCol *  ...
                double(sum((allEdges(:,1)==nodeIDs(n)) & (allEdges(:,2)) == seedList(s))>0);
        end
    end
end

%%Label specific cells
if 0
    crossoverAxons = [2032	2033	2034	2035]
    gotList = getList_giantBoutons(MPN);
    labelCells = gotList;
    for i = 1:length(labelCells)
        nodeCol(find(nodeIDs==labelCells(i)),:) = nodeCol(find(nodeIDs==labelCells(i)),:) + .5;
    end
end


nodeCol(nodeCol>1) = 1;
nodeCol(nodeCol<0) = 0;

%% Create springDat (need nodeCol, nodeIDs,

springIn.nodeIDs = nodeIDs;
springIn.allEdges = allEdges;
springIn.allWeights = allEdges ;
springIn.nodeCol = nodeCol;
springIn.nodeType = nodeType;
springIn.seedList = seedList;
springDat = springParameters_X01_figDraft(springIn);

springIn.allJuncs = [];%obI.nameProps.juncs(:,[1 2]);



if binaryMat
    springDat.edges.ew = springDat.edges.ew>0;
end

%% Run springs

for rerun = 1: 1
    
    %allResults{rerun} = runSprings(springDat);
    
    runSprings(springDat,result)
    set(gcf, 'InvertHardCopy', 'off');
    
    if 0
        
        imageName = sprintf('%sspringRun_%03.0f.png',springDir,rerun);
        imageName = sprintf('%s%s.png',springDir,itag);
        print(gcf,imageName,'-dpng','-r1024','-opengl','-noui')
        
        epsName = sprintf('%sspringRun_%03.0f.eps',springDir,rerun);
        epsName = sprintf('%s%s.eps',springDir,itag);
        print(gcf, epsName, '-depsc2','-painters')
        
    end
    
end

%% Save

if 0
    %% Save image
    
    %set(gcf,'PaperPositionMode','manual','PaperSize',[100 100],'PaperPosition',[1 1 1000 900])
    %set(gcf,'PaperPositionMode','auto','PaperPosition',[1 1 700 700])
    %set(gcf,'PaperPosition',[0 0 700 700])
    %set(gcf,'PaperPositionMode','auto')
    set(gcf,'PaperUnits','points','PaperPosition',[10 10 700 700])
    itag = 'colorGlom4_2x';
    imageName = sprintf('%sspringRun_%03.0f.png',springDir,rerun);
    imageName = sprintf('%s%s.png',springDir,itag);
    %print(gcf,imageName,'-dpng','-r1024','-opengl','-noui')
    
    epsName = sprintf('%s%s.eps',springDir,itag);
    print(gcf, epsName, '-depsc2','-painters','-r300')
    
    %%
end




%{

%% Save Results

result = allResults{rerun};
save([springRes 'res_all_05.mat'],'result')

%}


if 0
    %% Scale bar
    
    clf
    set(gcf,'Position',[1100 100 800 800],'visible','on')
    set(gca,'Position',[.5 .05 .05 .9])
    set(gcf,'color','k')
    colormap(colTable)
    image([0:size(colTable,1)]')
    ylim([1 100])
    set(gca,'Ydir','reverse')
    ticPos(1) = 1;
    set(gca,'YTick',ticPos,'YTickLabel',showRange,'XTick',[],'Ycolor','w')
    
    epsName = sprintf('%s%s_scaleBar.eps',springDir,itag);
    print(gcf, epsName, '-depsc2','-painters','-r300')
    
    
end
