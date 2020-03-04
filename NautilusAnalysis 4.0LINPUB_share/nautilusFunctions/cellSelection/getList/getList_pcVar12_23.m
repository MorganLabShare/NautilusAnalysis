function[cellIDs cellProps] = getList_pcVar12_23()


%%Rec res = cell is first aligned along principle components, then finds
%%Ratio of eigen values
cellProps = [    0.5839    0.6635
    0.6115    0.6274
    0.3998    0.4834
    0.3228    0.3566
    0.3547    0.6473
    0.4359    0.3453
    0.2967    0.5972
    0.4239    0.5022
    0.3151    0.4525
    0.5174    0.7702
    0.6559    0.5479
    0.2162    0.7192
    0.2063    0.6190
    0.5955    0.4835
    0.4916    0.2064
    0.4602    0.5925
    0.2152    0.5176
    0.4746    0.3663
    0.3377    0.5683
    0.2906    0.9522
    0.4757    0.5545
    0.6205    0.6789
    0.3744    0.7793
    0.6409    0.3690
    0.4191    0.2837
    0.6924    0.4307
    0.5333    0.6658
    0.6437    0.3222
    0.5493    0.2952
    0.6093    0.2681
    0.6845    0.3308
    0.4043    0.4866
    0.3303    0.6744
    0.4280    0.4481
    0.4798    0.5507
    0.3695    0.4193
    0.3927    0.6628
    0.3002    0.7852
    0.3424    0.4337
    0.7924    0.3137
    0.2561    0.5684
    0.4198    0.4576
    0.4629    0.6661]
cellIDs = [ 67
   108
   109
   110
   116
   117
   120
   123
   129
   130
   131
   133
   134
   135
   148
   156
   159
   162
   163
   169
   170
   201
   203
   205
   206
   207
   210
   212
   213
   215
   216
   217
   218
   224
   232
   237
   267
   268
   273
   601
   903
   907
   909];

[allTraced tracedAxons tracedTCR] = getList_tracedCells;

[cellIDs idxa idxb] = intersect(cellIDs, tracedTCR);
cellProps = cellProps(idxa,:);





