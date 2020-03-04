function[cellIDs cellProps] = getList_cardShape()


%%Rec res = cell is first aligned along principle components, then finds
%%Ratio of eigen values

recRes = [
    67.0000    1.1783    1.2286
  108.0000    0.8313    1.0634
  109.0000    0.4203    0.3600
  110.0000    0.3177    0.1553
  116.0000    0.5192    0.5569
  117.0000    0.4279    0.3165
  120.0000    0.3574    0.6864
  123.0000    0.3310    0.3565
  129.0000    0.3329    0.1651
  130.0000    0.7443    0.7081
  131.0000    0.6359    0.5299
  133.0000    0.2122    0.1240
  134.0000    0.1719    0.2614
  135.0000    0.5601    0.8467
  148.0000    0.6240    0.4946
  156.0000    0.4572    0.5396
  159.0000    0.2319    0.3488
  162.0000    0.5125    0.3321
  163.0000    0.5047    0.6085
  169.0000    0.1338    0.3537
  170.0000    0.5092    0.1893
  201.0000    0.5722    0.8608
  203.0000    0.2915    0.1232
  205.0000    0.4500    0.6648
  206.0000    0.5954    0.2155
  207.0000    0.6506    0.3106
  210.0000    0.5442    0.3492
  212.0000    1.3068    0.9779
  213.0000    0.7386    0.8288
  215.0000    0.5703    0.3153
  216.0000    1.0845    0.4439
  217.0000    0.5417    0.5897
  218.0000    0.2261    0.7602
  224.0000    1.0692    0.6178
  232.0000    0.7243    0.6529
  237.0000    0.5110    0.3700
  259.0000    1.0895    0.3820
  267.0000    0.2215    0.3410
  268.0000    0.2925    0.7217
  273.0000    0.4872    0.4698
  601.0000    0.6587    0.8248
  903.0000    0.2784    0.5500
  907.0000    0.4344    0.4423
  909.0000    0.6755    1.0845
  919.0000    0.2768    0.0840

    
];

cellIDs = recRes(:,1);
cellProps = recRes(:,2:end);

[allTraced tracedAxons tracedTCR] = getList_tracedCells;

[cellIDs idxa idxb] = intersect(cellIDs, tracedTCR);
cellProps = cellProps(idxa,:);





