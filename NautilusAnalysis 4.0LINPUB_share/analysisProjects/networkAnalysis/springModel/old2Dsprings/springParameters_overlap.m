function[springDat] = springParameters(springIn)


%% Create springDat (need nodeCol, nodeIDs, 

nodeIDs = springIn.nodeIDs;
allEdges = springIn.allEdges;
nodeCol = springIn.nodeCol;
nodeType = springIn.nodeType;
seedList = springIn.seedList;
allWeights = springIn.allWeights;

nodes.type = nodeType;

seed.list = seedList;
% seed.seedPref = synPref;
% seed.isPref = isPref;


%%Get new edges
[edges] = uniqueEdges(allEdges,nodeIDs); 

edgeCol = nodeCol(edges.e1,:);
edgeCol(edges.ew==0,:) = edgeCol(edges.ew==0,:)*.2;
edgeCol(edgeCol<0) = 0;
edgeCol(edgeCol>1) = 1;

edges.col = edgeCol;
edges.symmetry = edges.ew*0;
edges.width = edges.ew*0+.7;

nodes.labelIDs = nodeIDs;
nodes.color = nodeCol;

%%set param
param.k = .1;
param.disperse = 1;
param.centerSpring = 1;


param.reps = 2000;
param.zeroSeeds = 0;
param.noise = (param.reps:-1:1)/param.reps*10;
param.damp = .5;
param.fsize = 200;
param.speedMax = 1;
param.imageFreq = 10;

param.startRepulse = 500;%
param.repulse = 100; %1
param.minDist = 7;

%%Make groups
%sg = scatter(nodeX(group(g).ind),nodeY(group(g).ind),group(g).size,nodeCol(group(g).ind,:),group(g).marker,'filled');


springDat.groupNum = 2;
group(1).ind = find(nodeType==1);
group(2).ind = find(nodeType==2);
group(3).ind = find(nodeType==3);
group(1).marker = '^';
group(2).marker = 'o';
group(3).marker = 'o';
group(1).size = 100;
grooup(2).size = 5;
group(3).size = 300;
groupNum = length(group);
group(1).lineWidth = .5;
group(2).lineWidth = .7;
group(3).lineWidth = .7;


springDat.group = group;
springDat.param = param;
springDat.nodes = nodes;
springDat.edges = edges;
springDat.seed = seed;

