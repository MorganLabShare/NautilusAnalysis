
clear all
%SPN = 'E:\IxQ_KarlsRetinaVG3_2019\Merge\'; %GetMyDir;

load('MPN.mat')
MPN = GetMyDir;         

%% parse names

dMPN = dir(MPN);
c = 0;
fuse.exportDir = {};
for i = 1:length(dMPN)   
    nam = dMPN(i).name;
    if exist([MPN nam '\vastSubs.mat'],'file')
        c = c+1;
        fuse.exportDir{c} = nam;
    end 
end



%% merge subs
lastInd = 0;
allSubs = {};
clear allOb
allOb.fuse = fuse;
obSource = [];
for i = 1:length(fuse.exportDir)
    load([MPN fuse.exportDir{i} '\vastSubs.mat']);
    load([MPN fuse.exportDir{i} '\obI.mat']);
    
    numOb = length(obI.colStruc.names);
    
    obSource(length(obSource)+1:length(obSource)+numOb) = i;
    %     for n = 1:numOb
    %     allOb.colStruc.names{startInd+n-1} = obI.colStruc.names{n};
    %     allOb.colStruc.ids{startInd+n-1,:} = obI.colStruc.ids{n}+startInd-1;
    %     allOb.colStruc.anchors(startInd+n-1,:) = obI.colStruc.anchors(n,:);
    %     allOb.colStruc.boundBox(startInd+n-1,:) = obI.colStruc.boundBox(n,:);
    %     allOb.colStruc.col1(startInd+n-1,:) = obI.colStruc.col1(n,:);
    %     allOb.colStruc.col2(startInd+n-1,:) = obI.colStruc.col2(n,:);
    %     end
    
    if i == 1
        allOb.colStruc.info = obI.colStruc.info;
        allOb.colStruc.names = obI.colStruc.names;
        allOb.colStruc.ids = obI.colStruc.ids;
        allOb.colStruc.anchors = obI.colStruc.anchors;
        allOb.colStruc.boundBox =  obI.colStruc.boundBox;
        allOb.colStruc.col1 = obI.colStruc.col1;
        allOb.colStruc.col2 = obI.colStruc.col2;
        allOb.colStruc.parent = obI.colStruc.parent;
        allOb.colStruc.children = obI.colStruc.children;
        allSubs =vastSubs(1:numOb);
        allOb.em = obI.em;
    else
        
        allOb.colStruc.names = cat(2,allOb.colStruc.names,obI.colStruc.names)
        
        ids = obI.colStruc.ids + lastInd;
        allOb.colStruc.ids = cat(2,allOb.colStruc.ids,ids);
        allOb.colStruc.anchors = cat(1,allOb.colStruc.anchors,obI.colStruc.anchors)
        allOb.colStruc.boundBox = cat(1,   allOb.colStruc.boundBox, obI.colStruc.boundBox)
        allOb.colStruc.col1 = cat(1,allOb.colStruc.col1,obI.colStruc.col1);
        allOb.colStruc.col2 = cat(1,allOb.colStruc.col2,obI.colStruc.col2);
        allOb.colStruc.parent = cat(2,allOb.colStruc.parent,obI.colStruc.parent);
        allOb.colStruc.children = cat(2,allOb.colStruc.children,obI.colStruc.children);
        allSubs = cat(2,allSubs,vastSubs(1:numOb));
    end
    lastInd = max(allOb.colStruc.ids);
    allOb.fuse.mip(i) = obI.em.mipLevel;
end

allOb.fuse.obSource = obSource;
obI = allOb;
vastSubs = allSubs;

%%

obI.nameProps = getNameProps2019(obI.colStruc.names);
obI = getObiCellProps(obI);


save([MPN 'vastSubs.mat'],'vastSubs','-v7.3')
save([MPN 'obI.mat'],'obI')

%% Down sample vastSubs


mipLevs = obI.fuse.mip(obI.fuse.obSource);

res = obI.em.res; 
vRes = [2.^mipLevs' 2.^mipLevs' mipLevs'*0+1].* res;
dsRes = [200 200 200];
dsDim = repmat(dsRes,[size(vRes,1) 1])./vRes;

dsObj = downSampObj(MPN, dsDim);
% end


obI.em.res = res; %or [4.6 4 30]?
obI.em.vRes =vRes;
obI.em.dsRes =dsRes/1000;
save([MPN 'obI.mat'],'obI')




