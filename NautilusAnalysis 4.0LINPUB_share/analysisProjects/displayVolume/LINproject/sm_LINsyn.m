
if 0
    clear all
    load('D:\LGNs1\Analysis\sm.mat')
end

%%


synInd = find((sm.pre == 125) & (sm.postClass == 4));
preClass = [1 3 4 3 3 3];
postClass = [3 3 3 2 3 4]
imageNames = {'rgcIn' 'linIn' 'unkIn' 'tcOut' 'linOut' 'unkOut'};

for i = 1:length(imageNames)
    imageName = imageNames{i};
    if i<4
        synInd = find((sm.post == 125) & (sm.preClass == preClass(i)));
    else
        synInd = find((sm.pre == 125) & (sm.postClass == postClass(i)));
    end
    
    skelSize = 16
    clf, hold on, set(gca,'clipping','off', 'YDir','reverse'), axis off
    axis 'square'
    scatter(sm.bodySub(:,2),sm.bodySub(:,1),200,'o','filled','markerfacecolor',[.7 .7 .4])
    scatter(sm.shaftSub(:,2),sm.shaftSub(:,1),skelSize,'o','filled','markerfacecolor',[.5 .5 1])
    scatter(sm.targSub(:,2),sm.targSub(:,1),skelSize,'o','filled','markerfacecolor',[.4 .7 .4])
    scatter(sm.axSub(:,2),sm.axSub(:,1),skelSize,'o','filled','markerfacecolor',[1 .4 .4])
    
    synPos = sm.pos(synInd,:);
    synPos = synPos(sum(synPos>1,2)==3,:);
    %scatter(synPos(:,2),synPos(:,1),70,'o','filled','markerfacecolor',[0 0 0]);%, ...
    %    'markerfacealpha',.4);
    % scatter(synPos(:,2),synPos(:,1),50,'o','filled','markerfacecolor',[0 0 0], ...
    %     'markerfacealpha',.1);
    % scatter(synPos(:,2),synPos(:,1),20,'o','filled','markerfacecolor',[0 0 0], ...
    %     'markerfacealpha',.1);
    
    scatter(synPos(:,2),synPos(:,1),80,'o','linewidth',3,'markeredgecolor',[0 0 0]);%, ...
    
    imageDir = 'C:\Users\jlmorgan\Documents\Publications\LIN\Revision\Pics\SynOnProcType\'
    set(gcf,'PaperUnits','points','PaperPosition',[1 1 700 700])
    %set(gcf, 'InvertHardCopy', 'off');
    
    epsName = sprintf('%sspringRun_%s.eps',imageDir,imageName);
    %print(gcf, epsName, '-depsc2','-painters','-r300')
    
    print(gcf, epsName, '-dwinc','-painters','-r300')
    
    
    pngName = sprintf('%sspringRun_%s.png',imageDir,imageName);
%     print(gcf, pngName, '-dwinc','-painters','-r300')
    
%     saveas(gcf,pngName)
    
    
end




