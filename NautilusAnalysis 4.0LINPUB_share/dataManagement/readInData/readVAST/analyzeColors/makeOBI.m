function[obI] = makeOBI(TPN)

%MPN =       'D:\LGNs1\Segmentation\VAST\S8\joshm\export+14+04+27_mat\'


obI.colStruc = readVastColors2019;
obI.nameProps = getNameProps2019(obI.colStruc.names);
obI = getObiCellProps(obI);



save([TPN 'obI.mat'],'obI');















