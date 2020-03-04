function[syn] = getSynMat(obI);

if ~exist('obI','var')
load('MPN.mat')
load([MPN 'obI.mat'])
end


allEdges = obI.nameProps.edges;

%% cell types
cells = unique([ obI.nameProps.cellNum' ; allEdges(:,1); allEdges(:,2)]);
if isfield(obI.cell, 'mainObID')
    rgcs = obI.cell.name(obI.nameProps.rgc(obI.cell.mainObID));
    tcrs = obI.cell.name(obI.nameProps.tcr(obI.cell.mainObID));
    lins = obI.cell.name(obI.nameProps.lin(obI.cell.mainObID));
    unks = obI.cell.name(obI.nameProps.unk(obI.cell.mainObID));
else
    rgcs = obI.cell.name(obI.nameProps.rgc(obI.cell.mainID));
    tcrs = obI.cell.name(obI.nameProps.tcr(obI.cell.mainID));
    lins = obI.cell.name(obI.nameProps.lin(obI.cell.mainID));
    unks = obI.cell.name(obI.nameProps.unk(obI.cell.mainID));
end

cells = setdiff(cells,0);
rgcs = setdiff(rgcs,0);
tcrs = setdiff(tcrs,0);
lins = setdiff(lins,0);
unks = setdiff(unks,0);

types.rgcs = rgcs;
types.tcrs = tcrs;
types.lins = lins;
types.unks = unks;

syn.pre = allEdges(:,2);
syn.post = allEdges(:,1);
syn.obID = allEdges(:,3);


%% Get list of positions

anchors = double(obI.colStruc.anchors);
rawAnchors = anchors;

umSamp = (obI.em.res .* [4 4 1])./1000;
UManchors(:,1) = anchors(:,1)*umSamp(1);
UManchors(:,2) = anchors(:,2)*umSamp(2);
UManchors(:,3) = anchors(:,3)*umSamp(3);


dSamp =  (obI.em.res .* [4 4 1])./1000./obI.em.dsRes;
anchors(:,1) = anchors(:,1)*dSamp(1);
anchors(:,2) = anchors(:,2)*dSamp(2);
anchors(:,3) = anchors(:,3)*dSamp(3);
anchors = round(anchors);
anchors(anchors<1) = 1;

%% Get synapse  positions

synSyn = []; synPos = []; synPosRaw = [];
for i = 1:size(syn.obID,1)
        synPosDS(i,:) = anchors(syn.obID(i),:);
        synPosRaw(i,:) = rawAnchors(syn.obID(i),:);    
        synPosUM(i,:) = UManchors(syn.obID(i),:);    

end

syn.synPos = synPosUM;
syn.synPosRaw = synPosRaw;
syn.synPosDS = synPosDS;

syn.order = 'pre to post';

%% cell types

classes = zeros(max(cells),1);
classes(rgcs+1) = 1;
classes(tcrs+1) = 2;
classes(lins+1) = 3;
classes(unks+1) = 4;
typeNames = {'rgc' 'tcr' 'lin' 'unk'};

syn.preClass = classes(syn.pre+1);
syn.postClass = classes(syn.post+1);
syn.typeNames = typeNames;



























