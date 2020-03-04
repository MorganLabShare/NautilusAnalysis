
if 0
    clear all
    load('MPN.mat')
    load('D:\LGNs1\Analysis\sm.mat')
end

length(find((sm.preClass == 1) & (sm.post == 125)))
length(find((sm.preClass == 2) & (sm.post == 125)))
length(find((sm.preClass == 3) & (sm.post == 125)))
length(find((sm.preClass == 4) & (sm.post == 125)))

length(find((sm.postClass == 1) & (sm.pre == 125)))
length(find((sm.postClass == 2) & (sm.pre == 125)))
length(find((sm.postClass == 3) & (sm.pre == 125)))
length(find((sm.postClass == 4) & (sm.pre == 125)))

       
       
       
       
       
       
       
       
       