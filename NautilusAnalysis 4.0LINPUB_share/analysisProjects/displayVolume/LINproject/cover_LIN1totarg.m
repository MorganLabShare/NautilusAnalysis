
if 0
    load('MPN.mat')
    load([MPN 'obI.mat'])
    load([MPN 'dsObj.mat'])
    load('D:\LGNs1\Analysis\sm.mat')
    
    mot = getMotifs(obI);
    rgcs = mot.cel.types.rgcs;
    tcrs = mot.cel.types.tcrs;
    lins = mot.cel.types.lins;
    
    seedList = 125;
    allEdges = obI.nameProps.edges;
    Pre = postTo(allEdges,seedList);
    Post = preTo(allEdges,seedList);
    allPart = unique([Pre(:,1); Post(:,1)])';
    
    TCR = setdiff(intersect([Post(:,1)],tcrs),seedList)';
    RGC = [5102 9102 1037 9019 2027]; %setdiff(intersect([Pre(:,1)],rgcs),seedList)';
    LINout = setdiff(intersect([Post(:,1)],lins),seedList)';
    LINin = setdiff(intersect([Pre(:,1)],lins),seedList)';
    
end

%% load 125 skel
sFile = sprintf('%s%d.mat',SPN,125);
load(sFile)
scatter(cellStruct.surfVox.subs(:,1),cellStruct.surfVox.subs(:,2),'.')
nodes = cat(1,cellStruct.arbor.branches.nodes);
edges = cellStruct.arbor.branches.edges;
pos125 = cellStruct.arbor.nodes.node2subs(nodes,:);
scatter3(pos125(:,1),pos125(:,2),pos125(:,3),'.')

%% Render 125
c  = 0;
clf
hold on
dim = [1 2 3];
startAngle = [0 0];
downSamp = 2;
renderProps.smooth = 0;
renderProps.resize = 1;
renderProps.smoothPatch = 4;
deSat = 0;

targSub = shrinkSub(sm.subs(sm.subType==1,dim),downSamp);
shaftSub = shrinkSub(sm.subs(sm.subType==3,dim),downSamp);
axSub = shrinkSub(sm.subs(sm.subType==2,dim),downSamp);
cbSub = shrinkSub(sm.subs(sm.subType==4,dim),downSamp);
centCB = mean(cbSub,1);

targSub = subDilate(subDilate(targSub));
shaftSub = subDilate(subDilate(shaftSub));
axSub = subDilate(subDilate(axSub));
cbSub = subDilate(subDilate(cbSub));


ball = patchShape('sphere',40/downSamp);
cb125 = ball;
cb125.vertices = cb125.vertices + repmat(centCB,[size(cb125.vertices,1) 1])
%bl = patchShape('sphere',20/downSamp);

col125 = [1 0 .4];

targFV = subVolFV(shrinkSub(targSub,downSamp),[],renderProps);
renderFV(upScaleFV(targFV,downSamp),col125,.5)

shaftFV = subVolFV(shrinkSub(shaftSub,downSamp),[],renderProps);
renderFV(upScaleFV(shaftFV,downSamp),col125,.5)

cbFV = subVolFV(shrinkSub(cbSub,downSamp),[],renderProps);
renderFV(upScaleFV(cbFV,downSamp),col125,.5)

axFV = subVolFV(shrinkSub(axSub,downSamp),[],renderProps);
renderFV(upScaleFV(axFV,downSamp),col125,.5)

 renderFV(cb125,col125,1)

 set(gca,'clipping','off')
axis off

%% 
%anc2DS = (obI.em.vRes/1000 )
anc2DS = (obI.em.res .* [4 4 1])./1000 /2*5;

%anc2DS =  obI.em.res .* [8 8 1]  ./obI.em.dsRes/1000
allAnchors = obI.colStruc.anchors;
%scatter(allAnchors(:,1),allAnchors(:,2),'.','k')
allDS = allAnchors(:,[1 2 3]) .* repmat(anc2DS,[size(allAnchors,1) 1]);
max(allDS,[],1)

SPN = 'D:\LGNs1\mergeSeg_mat\skel\mat\'


%scatter3(pos125(:,1),pos125(:,2),pos125(:,3),'.','r')
view = ([44 44])
l = lightangle(44,44);
badSkel = [66 239 254 262];
useTCR = setdiff(1:length(TCR),badSkel)


for i = useTCR
        
    doCell = TCR(i);
    sFile = sprintf('%s%d.mat',SPN,doCell);
    load(sFile)
    %nodes = cat(1,cellStruct.arbor.branches.nodes);
    edges = cat(1,cellStruct.arbor.branches.edges,cellStruct.arbor.bridges);
    nodes = unique(edges(:));
    pos = cellStruct.arbor.nodes.node2subs;
    lengths = sqrt((pos(edges(:,1),1)-pos(edges(:,2),1)).^2 + ...
        (pos(edges(:,1),2)-pos(edges(:,2),2)).^2 + ...
        (pos(edges(:,1),3)-pos(edges(:,2),3)).^2);
    
    pos = pos;
    %pos = pos+repmat(cellStruct.arbor.offset,[size(pos,1) 1]);
    %scatter3(pos(:,1),pos(:,2),pos(:,3),'.','b')
    hold on
    min(pos,[],1),max(pos,[],1)
    
    targ = find(obI.cell.name == doCell,1);
    cbAnchor = obI.cell.anchors(targ,:);
    cbDS = cbAnchor .* repmat(anc2DS,[size(cbAnchor,1) 1]);
    
    isSyn = allEdges([(allEdges(:,1) == doCell) & (allEdges(:,2) == 125)],3);
    synAnchors = obI.colStruc.anchors(isSyn,:);
    synDS = synAnchors .* repmat(anc2DS,[size(synAnchors,1) 1]);
        
    %% Get Nodes
    dist = sqrt((pos(:,1)-cbDS(1)).^2 + (pos(:,2)-cbDS(2)).^2 + (pos(:,3)-cbDS(3)).^2);
    cbNode = nodes(find(dist==min(dist),1));
    
    if sum(cbDS)>10
    
    clear synNode
    for s = 1:size(synDS,1)
        dist = sqrt((pos(:,1)-synDS(s,1)).^2 + (pos(:,2)-synDS(s,2)).^2 + (pos(:,3)-synDS(s,3)).^2);
        synNode(s) = nodes(find(dist==min(dist),1));
    end
    
    for s = 1:length(synNode)
        try
            pp = node2nodeDist(edges,lengths,cbNode,synNode(s));
        catch err
            pp = [];
        end
        
        if ~isempty(pp)
            
            scatter3(synDS(:,1),synDS(:,2),synDS(:,3),20,'o','w','filled')
            %scatter3(cbDS(:,1),cbDS(:,2),cbDS(:,3),300,'o','b','filled')
            pathNodes = unique(pp.path);
            pathNodes = pathNodes(1:5:end);
%             scatter3(pos(pathNodes,1),pos(pathNodes,2),...
%                 pos(pathNodes,3),50,'.','w')
            %path = pp.path;
           
            path = pp.path(1,1);
            for p = 1:size(pp.path,1);
                t = find(pp.path(:,1) == path(end),1);
                path = [path pp.path(t,2)];
            end
           
            p1 = plot3(pos(path',1),pos(path',2),pos(path',3),...
                'linewidth',1,'color','y')
            p1.Color(4) = 1;
           
            ballCB = ball;
            ballCB.vertices = ballCB.vertices + repmat(cbDS,[size(ballCB.vertices,1) 1]);
            ballCB.FaceAlpha = .1;
            renderFV(ballCB,[1 1 .5],.4)
            
        end
    end
    end
    pause(.01)
    
end






















