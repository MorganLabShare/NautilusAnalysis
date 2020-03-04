

%% Get data
loadData = 1;
if loadData
    clear all
    %MPN = GetMyDir;
    load('MPN.mat');
    WPN = MPN;
    DPN = [MPN 'data\'];
    if ~exist(DPN,'dir'),mkdir(DPN);end
    
    load([MPN 'obI.mat']);
    seedList = [ 108 201 907 903 125];
    plusOne = 125;
    %seedList = [ 108  201 109 ];
    
    % useList = obI2cellList_seedInput_RGC_TCR(obI,seedList);
    
    allEdges = obI.nameProps.edges(:,[2 1]);
    
end

show = 1

postList = allEdges(:,2);
postList = unique(postList(postList>0));
%load([springRes 'turkey_plusOne125.mat'])

cells = obI.cell.name(obI.cell.isCell>0);
cellList = intersect(postList,cells);
%% Get skeletons
skelList = cellList;
minTip = 1;
minSpace = 1;


load([MPN 'nep\skelNep125.mat'])
load([MPN 'nep\useSynPos125.mat'])
pos = nep.nodePos;
edges = nep.edges;
lengths = sqrt((pos(edges(:,1),1)-(pos(edges(:,2),1))).^2 + ...
                    (pos(edges(:,1),2)-(pos(edges(:,2),2))).^2 + ...
                    (pos(edges(:,1),3)-(pos(edges(:,2),3))).^2);

points1 = useSynPos.fromRGC_dat;
points2 = useSynPos.synPos125toTCR;

points1 = points1(sum(points1,2)>0,:);
points2 = points2(sum(points2,2)>0,:);

nepSyn = obISyn2nep(obI);
%nepSyn = linkSyn2Skel(nepSyn,skels);



%% One at a time


syn = nepSyn.cellEdges

    cellID = 125;
    skel = nep;
    sPos = skel.nodePos;
    
    isSyn = find(syn(:,2) == cellID);
    
    if length(isSyn)>1
        synPos = nepSyn.nodePos(isSyn,:);
        syns = 1:length(isSyn);
        
        pairs = nchoosek(syns,2);
        clear pLength eucDist keepPaths keepLengths
                
        for p = 1:size(pairs,1)
            
            pos1 = synPos(pairs(p,1),:);
            pos2 = synPos(pairs(p,2),:);
            
            eucDist(p) = sqrt((pos1(1)-pos2(1)).^2 + (pos1(2)-pos2(2)).^2 + ...
                (pos1(3)-pos2(3)).^2 );
            
            
            syn2Skel = sqrt((sPos(:,1)-pos1(1)).^2 + (sPos(:,2)-pos1(2)).^2 + ...
                (sPos(:,3)-pos1(3)).^2 );
            link1 = (find(syn2Skel==min(syn2Skel),1));
            
            syn2Skel = sqrt((sPos(:,1)-pos2(1)).^2 + (sPos(:,2)-pos2(2)).^2 + ...
                (sPos(:,3)-pos2(3)).^2 );
            link2 = (find(syn2Skel==min(syn2Skel),1));
            
            %% find path
            if link1 ~= link2
                edges = skel.edges;
                nodePos = sPos;
                startNode = link1;
                stopNode = link2;
                                 
                pp = node2nodeDist(edges,lengths,startNode,stopNode);
                pp = node2nodeDist(edges,lengths,startNode);
                
                scatter3(sPos(:,1),sPos(:,2),sPos(:,3),2,'k','filled')
                scatter3(sPos(:,1),sPos(:,2),sPos(:,3),[],pp.dists)
                hold on
                scatter3(sPos(startNode,1),sPos(startNode,2),sPos(startNode,3),300,'g','filled')
                scatter3(sPos(stopNode,1),sPos(stopNode,2),sPos(stopNode,3),300,'r','filled')
                hold off
                
                
                
%                 %% path length
%                 clear pLengths
%                 for pa = 1:size(path,1)
%                     pLengths(pa) = sqrt((sPos(path(pa,1),1) - sPos(path(pa,2),1)).^2 + ...
%                         (sPos(path(pa,1),2) - sPos(path(pa,2),2)).^2 +...
%                         (sPos(path(pa,1),3) - sPos(path(pa,2),3)).^2);
%                     plot3(sPos(path(pa,:),1),sPos(path(pa,:),2),...
%                         sPos(path(pa,:),3),'r','linewidth',4)
%                 end
                
                pLength(p) = max(cumDist);
                keepPaths{p} = path;
                keepLengths{p} = cumDist;
                
                %% show path
                if show
                scatter3(pos1(1),pos1(2),pos1(3),'r','filled')
                scatter3(pos2(1),pos2(2),pos2(3),'g','filled')
                scatter3(sPos(link1,1),sPos(link1,2),sPos(link1,3),'m','filled')
                scatter3(sPos(link2,1),sPos(link2,2),sPos(link2,3),'c','filled')
                
                scatter3(sPos(path(:),1),sPos(path(:),2),sPos(path(:),3),'b','filled')
                sum(pLengths)
                eucDist(p);
                pathRat = sum(pLengths)/eucDist(p);
                pause(.1)
                %pause
                hold off
                end
                
            else % same node on arbor
                pLength(p) = 0;
                 keepPaths{p} = [];
                keepLengths{p} = [];
            end
            
        end %run all pairs
        
    else % no pairs on cell
        pLength = [];
        eucDist = [];
        keepPaths = [];
        keepLengths = [];
    end
    
    cellDists(i).pLength = pLength;
    cellDists(i).eucDist = eucDist;
    cellDists(i).cellName = skelList(i);
    cellDists(i).keepPaths = keepPaths;
    cellDists(i).keepLengths = keepLengths;
    cellDists(i).sPos = sPos;


topoPairDists = cellDists;
save([DPN 'topoPairDists4.mat'],'topoPairDists')


%% Plot 

c = 0;
clear eucDists pLengths
for t = 1:length(topoPairDists)
    pLength = topoPairDists(t).pLength;
    eucDist = topoPairDists(t).eucDist;
    for p = 1:length(pLength)
        c = c+1;
        eucDists(c) = eucDist(p);
        pLengths(c) = pLength(p);
    end
end

scatter(eucDists,pLengths,'k','o','filled')
hold on
plot([0 30],[0 30],'r')
hold off




if 0
    %% test edges
    edges = skel.edges;
    startNode = 1
    
    scatter(sPos(:,1),sPos(:,2),'k','filled')
    hold on
    
    lastNode = startNode;
    clear path
    use = edges * 0 + 1;
    
    for pa = 1:size(edges,1)
        scatter3(sPos(lastNode,1),sPos(lastNode,2),sPos(lastNode,3),'b','filled')
        pause(.01)
        predNode = [];
        for n = 1:length(lastNode)
            [e a] = find((edges==lastNode(n)) & ( use));
            b = 3-a;
            predNode = cat(1,predNode,edges(sub2ind(size(edges),e,b)));
            %path(pa,:) = [predNode lastNode];
            use(e,:) = 0;
        end
        lastNode = unique(predNode);
        
        
    end
    
    
    hold off
    
    
    
    
end



