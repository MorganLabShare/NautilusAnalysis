
if 0
    clear all
    load('D:\LGNs1\Analysis\sm.mat')
end
imageDir = 'C:\Users\jlmorgan\Documents\Publications\LIN\Revision\Pics\GraphAb_01\'
if ~exist(imageDir,'dir'),mkdir(imageDir),end
shouldWrite = 0;

%%
c  = 0;

dim = [2 3 1];
startAngle = [0 0];
downSamp = 2;
renderProps.smooth = 0;
renderProps.resize = 1;
renderProps.smoothPatch = 4;
    
synInd = find((sm.pre == 125) & (sm.postClass == 4));
showClass = [1 2 ];
showPre = [1 0];
imageNames = {'rgcIn' 'linIn' 'unkIn' 'tcOut' 'linOut' 'unkOut'};
markerCol = [.5 1 0; .5 .3 1; 1 0 .9];
%markerText = {'R', 'L', 'U', 'T', 'L','O'};
markerText = {'I', 'I', 'I', 'O', 'O', 'O'};
alph = 1;

%% Make fv
targSub = shrinkSub(sm.subs(sm.subType==1,dim),downSamp);
shaftSub = shrinkSub(sm.subs(sm.subType==3,dim),downSamp);
axSub = shrinkSub(sm.subs(sm.subType==2,dim),downSamp);
cbSub = shrinkSub(sm.subs(sm.subType==4,dim),downSamp);
centCB = mean(cbSub,1);

targSub = subDilate(subDilate(targSub));
shaftSub = subDilate(subDilate(shaftSub));
axSub = subDilate(subDilate(axSub));
cbSub = subDilate(subDilate(cbSub));


ball = patchShape('sphere',40/downSamp);
ball.vertices = ball.vertices + repmat(centCB,[size(ball.vertices,1) 1])

bl = patchShape('sphere',15/downSamp);


%%
% 
% clf
% patch(ball)
% renderCon(targSub,[],[.7 1 .7],.5)
% renderCon(shaftSub,[],[.7 .7 1],.5)
% renderCon(cbSub,[], [1 1 .7],.5)
% renderCon(axSub, [], [ 1 .7 .7],.5)
% renderFV(ball,[1 1 .7],1)
% hold on
% view(startAngle)
l = lightangle(90,100);



%%

c = 0;
     i = 1;   
        clf
        
        if i == 1
            patch(ball)
        end
                
        deSat = .5;
        linCol = [1 0 0];
        %renderCon(targSub,[],[deSat 1 deSat],.5)
        targFV = subVolFV(shrinkSub(targSub,downSamp),[],renderProps);
        %scatter3(targSub(:,1),targSub(:,2),targSub(:,3),'.','w')
        renderFV(upScaleFV(targFV,downSamp),linCol,alph)
                   
        %renderCon(shaftSub,[],[deSat deSat 1],.5)
        shaftFV = subVolFV(shrinkSub(shaftSub,downSamp),[],renderProps);
        renderFV(upScaleFV(shaftFV,downSamp),linCol,alph)
        
        %renderCon(cbSub,[], [1 1 deSat],.5)
        cbFV = subVolFV(shrinkSub(cbSub,downSamp),[],renderProps);
        renderFV(upScaleFV(cbFV,downSamp),linCol,alph)
        
        %renderCon(axSub, [], [ 1 deSat deSat],.5)
        axFV = subVolFV(shrinkSub(axSub,downSamp),[],renderProps);
        renderFV(upScaleFV(axFV,downSamp),linCol,alph)       
        
        renderFV(ball,[1 0 0],1)
        hold on
        view(startAngle)
        l = lightangle(90,100);
        set(gcf,'color',[1 1 1])
        set(gca, 'ZDir','reverse')       
        
    end
    
    %imageName = imageNames{i};
    if showPre(i)
        synInd = find((sm.post == 125) & (sm.preClass == showClass(i)));
    else
        synInd = find((sm.pre == 125) & (sm.postClass == showClass(i)));
    end
    
    %disp(sprintf('%s %d',imageName, length(synInd)))
    %
    synPos = sm.pos(synInd,dim)/.2 /downSamp;
    synPos = synPos(sum(synPos>1,2)==3,:);
    set(gca,'clipping','off' ), axis off
    
    for b = 1:size(synPos,1);
        bs = bl;
       
        bs.vertices = bl.vertices + repmat(synPos(b,:),[size(bl.vertices,1) 1])
        bsPatch = renderFV(bs,markerCol(showClass(i),:),alph);
         bsPatch.AmbientStrength = .1;
        bsPatch.DiffuseStrength = 1;%.1;
        bsPatch.SpecularStrength = 0;
        bsPatch.SpecularExponent = 20;
        bsPatch.BackFaceLighting = 'lit';
    end
    
    %text(synPos(:,1), synPos(:,2),synPos(:,3),['\bf' markerText{i}],'Color',...
    %         markerCol(i,:),'FontSize',10, 'HorizontalAlignment','center')
    % set(gca,'ydir','reverse')
    %     set(gcf,'PaperUnits','points','PaperPosition',[1 1 700 700])
    %epsName = sprintf('%sspringRun_%s.eps',imageDir,imageName);
    %print(gcf, epsName, '-dwinc','-painters','-r300')
    %     pngName = sprintf('%sspringRun_%s.png',imageDir,imageName);
    %          print(gcf, pngName, '-dwinc','-painters','-r300')
    %
    %     saveas(gcf,pngName)
    
    pause(.1)
    
end
 



 az = [0];
 c = 0;
 for a = 1:length(az);
     c = c + 1;
     view([startAngle(1) + az(a), startAngle(2)])
     lightangle(l,startAngle(1) + az(a), startAngle(2)+180)
     
     axis off
     set(gcf,'PaperUnits','points','PaperPosition',[1 1 1024 1024])
     %runSprings(springDat,allResults{1})
     set(gcf, 'InvertHardCopy', 'off');
     set(gcf,'color',[1 1 1])
     imageName = sprintf('%srot_%05.0fb.png',imageDir,c);
     %print(gcf,imageName,'-dpng','-r1024','-opengl','-noui')
     if shouldWrite
         print(gcf, imageName, '-dpng','-opengl','-r1024')
     end
     pause(.01)
 end


%% Wright whatever is being shown

if 0
    
     view([startAngle(1) + az(a), startAngle(2)])
     lightangle(startAngle(1) + az(a), startAngle(2)+180)
     
     axis off
     set(gcf,'PaperUnits','points','PaperPosition',[1 1 1024 1024])
     %runSprings(springDat,allResults{1})
     set(gcf, 'InvertHardCopy', 'off');
     set(gcf,'color',[1 1 1])
     imageName = sprintf('%sasDisplayed2.png',imageDir);
     %print(gcf,imageName,'-dpng','-r1024','-opengl','-noui')
     if shouldWrite
         print(gcf, imageName, '-dpng','-opengl','-r1024')
     end
     pause(.01)
    
   
    
    
    
    
    
end

