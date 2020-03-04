function[sm] = makeSM()

   
    load('MPN.mat')
    load([MPN 'obI.mat'])
    load([MPN 'dsObj.mat'])
    
    sm = addDatToSynMat(obI)
    sm = getTopoEucDistBetweenSyn(sm);
    sm = getSkelForSM(sm);
    sm = getSkelProps(sm);
    sm = getTopoEucDistBetweenSkelAndSyn(sm);
    sm = labelShaftSkel(sm);
    sm = labelSubTypes(sm);
    sm = synSkel2synSkelDist(sm);
    save('D:\LGNs1\Analysis\sm.mat','sm','-v7.3')
    sm = skel2skelDist(sm);
    save('D:\LGNs1\Analysis\sm.mat','sm','-v7.3')

    