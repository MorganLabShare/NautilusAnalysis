function[] = viewManyCells(targCell);

MPN = 'D:\LGNs1\Segmentation\VAST\S8\joshm\export_14+04+25_matOut\'

load([MPN 'dsObj.mat'])
load([MPN 'obI.mat'])



fsize = findObSize(dsObj);

%% draw synapses

%targCell = 1054;
dotSize = 30; Dim = 1; dotColor = [0 1 0]; downSamp = 4;

preHits = find(obI.nameProps.edges(:,1) == targCell);
postHits =  find(obI.nameProps.edges(:,2) == targCell);
preCellList = obI.nameProps.edges(preHits,2);
postCellList = obI.nameProps.edges(postHits,1);
allCellList = [preCellList postCellList];

hits = [preHits(:)' postHits(:)'];
hitIDs = obI.nameProps.edges(hits,3);
hitPoints = obI.colStruc.anchors(hitIDs(hitIDs<length(obI.colStruc.anchors)),:);

cellId = unique(allCellList(allCellList>0));
col = rand(length(cellId),3);
colMap = hsv(256);
col = colMap(ceil((1:length(cellId))*256/length(cellId)),:)
I_preTargCell = showCellSum(obI,dsObj,cellId,col,Dim,fsize)*30;
sumDir = [MPN 'sumImages\rgc\'];
%cells2Dir(obI,dsObj,cellId,Dim,sumDir);


%I_targCell = showCell(obI,dsObj,targCell,[1,1,1],Dim);
I_targCellSum = showCellSum(obI,dsObj,targCell,[1,1,1],Dim,fsize)*30;


targCells = unique(preCellList(preCellList>0));
partCells = [];
for i = 1: length(targCells)
    postHits =  find(obI.nameProps.edges(:,2) == targCells(i));
    postCellList = obI.nameProps.edges(postHits,1); 
    preHits =  find(obI.nameProps.edges(:,1) == targCells(i));
    preCellList = obI.nameProps.edges(preHits,2); 
    
    partCells = cat(1,partCells,postCellList,preCellList);    
end
partCells = unique(partCells(partCells>0));

col = colMap(ceil((1:length(partCells))*256/length(partCells)),:)
I_partCell = showCellSum(obI,dsObj,partCells,col,Dim,fsize)*30;
sumDir = [MPN 'sumImages\relay\'];
%cells2Dir(obI,dsObj,partCells,Dim,sumDir);


%% combind images
I_comb = I_preTargCell;
%imwrite(I_preTargCell,[MPN 'sumImages\I_preTargCell.png'])
%imwrite(I_partCell,[MPN 'sumImages\I_partCell.png'])

I_comb(I_comb == 0) = I_targCellSum(I_comb==0);
I_comb = I_comb + I_partCell/3;
image(I_comb)

I_rgb = cat(3,mean(I_preTargCell,3),mean(I_targCellSum,3),mean(I_partCell,3));
image(uint8(I_rgb))
imwrite(uint8(I_rgb),[MPN 'sumImages\axTarg2\' sprintf('%d.png',targCell)])


return
% 
% hits =  find(nameProps.cell & nameProps.cellNum == 108);
% hitPoints = obj.info.anchors(hits,:);


hitI = drawAnchors(obj.fsize,hitPoints,Dim,downSamp,dotSize,dotColor);


    colList = chooseObjCol_firstCohort(obj.info.nameProps,targCell);
    colI = showObjCol(colList,sumFold,fileNames,Dim);
    
    image(uint8(colI))
    

comI = hitI;
comI(1:size(colI,1),1:size(colI,2),:) = hitI(1:size(colI,1),1:size(colI,2),:) + colI;
image(uint8(comI))