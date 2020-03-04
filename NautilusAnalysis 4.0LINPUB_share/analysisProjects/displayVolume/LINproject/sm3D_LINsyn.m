
if 0
    clear all
    load('D:\LGNs1\Analysis\sm.mat')
end
imageDir = 'C:\Users\jlmorgan\Documents\Publications\LIN\Revision\Pics\SynOnProcType3D_fv4\'
if ~exist(imageDir,'dir'),mkdir(imageDir),end
shouldWrite = 1;

%%
c  = 0;

dim = [2 3 1];
startAngle = [0 0];
downSamp = 2;
renderProps.smooth = 0;
renderProps.resize = 1;
renderProps.smoothPatch = 4;
    
synInd = find((sm.pre == 125) & (sm.postClass == 4));
preClass = [0 0 0 1 3 4 3 3 3];
postClass = [0 0 0 3 3 3 2 3 4]
imageNames = {'rgcIn' 'linIn' 'unkIn' 'tcOut' 'linOut' 'unkOut'};
markerCol = [0 1 0; 0 1 0; 0 1 0; 0 1 0; 1 0 0; 1 1 1; 0 0 1; 1 0 0; 1 1 1];
%markerText = {'R', 'L', 'U', 'T', 'L','O'};
markerText = {'I', 'I', 'I', 'O', 'O', 'O'};

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
bl = patchShape('sphere',20/downSamp);


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
for i = 1:length(preClass)
    
    
    
    if (i == 1) | (i == 4)| (i == 7)
        clf
        
        if i == 1
            patch(ball)
        end
        
        
        if i<4, deSat = 0; else, deSat = .7; end
        %renderCon(targSub,[],[deSat 1 deSat],.5)
        targFV = subVolFV(shrinkSub(targSub,downSamp),[],renderProps);
        %scatter3(targSub(:,1),targSub(:,2),targSub(:,3),'.','w')
        renderFV(upScaleFV(targFV,downSamp),[deSat 1 deSat],.5)
        
        %renderCon(shaftSub,[],[deSat deSat 1],.5)
        shaftFV = subVolFV(shrinkSub(shaftSub,downSamp),[],renderProps);
        renderFV(upScaleFV(shaftFV,downSamp),[deSat deSat 1],.5)
        
        %renderCon(cbSub,[], [1 1 deSat],.5)
        cbFV = subVolFV(shrinkSub(cbSub,downSamp),[],renderProps);
        renderFV(upScaleFV(cbFV,downSamp),[1 1 deSat],.5)
        
        %renderCon(axSub, [], [ 1 deSat deSat],.5)
        axFV = subVolFV(shrinkSub(axSub,downSamp),[],renderProps);
        renderFV(upScaleFV(axFV,downSamp),[ 1 deSat deSat],.5)       
        
        renderFV(ball,[1 1 deSat],1)
        hold on
        view(startAngle)
        l = lightangle(90,100);
        set(gca, 'ZDir','reverse')
        
        
        
        
        
        
        if i == 1
            text(centCB(1), centCB(2) + 200,centCB(3)/2,['\bf' 'Targeting'],'Color',...
                [0 1 0],'FontSize',20, 'HorizontalAlignment','left')
            text(centCB(1), centCB(2)+ 200,centCB(3)/2 + 120,['\bf' 'Dendrites'],'Color',...
                [0 1 0],'FontSize',20, 'HorizontalAlignment','left')
            text(centCB(1), centCB(2)+ 200,centCB(3)/2+240,['\bf' 'Trunk Dendrites'],'Color',...
                [ 0 0 1],'FontSize',20, 'HorizontalAlignment','left')
            text(centCB(1), centCB(2)+ 200,centCB(3)/2+360,['\bf' 'Axon'],'Color',...
                [ 1 0 0],'FontSize',20, 'HorizontalAlignment','left')
            text(centCB(1), centCB(2)+ 200,centCB(3)/2 + 480,['\bf' 'Cell body'],'Color',...
                [ 1 1 0],'FontSize',20, 'HorizontalAlignment','left')
        elseif i == 4
            text(centCB(1), centCB(2)+ 200,centCB(3)/2,['\bf' 'Input'],'Color',...
                [ 1 1 1],'FontSize',30, 'HorizontalAlignment','left')
            text(centCB(1), centCB(2)+ 200,centCB(3)/2 + 120,['\bf' 'RGC'],'Color',...
                [0 1 0],'FontSize',20, 'HorizontalAlignment','left')
            text(centCB(1), centCB(2)+ 200,centCB(3)/2+240,['\bf' 'LIN'],'Color',...
                [ 1 0 0],'FontSize',20, 'HorizontalAlignment','left')
            text(centCB(1), centCB(2)+ 200,centCB(3)/2+360,['\bf' 'Unknown'],'Color',...
                [ .7 .7 .7],'FontSize',20, 'HorizontalAlignment','left')
            
            
            
        else
            text(centCB(1), centCB(2)+ 200,centCB(3)/2,['\bf' 'Output'],'Color',...
                [ 1 1 1],'FontSize',30, 'HorizontalAlignment','left')
            text(centCB(1), centCB(2)+ 200,centCB(3)/2 + 120,['\bf' 'TC'],'Color',...
                [.2 .2 1],'FontSize',20, 'HorizontalAlignment','left')
            text(centCB(1), centCB(2)+ 200,centCB(3)/2+240,['\bf' 'LIN'],'Color',...
                [ 1 0 0],'FontSize',20, 'HorizontalAlignment','left')
            text(centCB(1), centCB(2)+ 200,centCB(3)/2+360,['\bf' 'Unknown'],'Color',...
                [ .7 .7 .7],'FontSize',20, 'HorizontalAlignment','left')
            
        end
        
        
        
        
        
    end
    
    %imageName = imageNames{i};
    if i <4
        synInd = [];
    elseif  i<7
        synInd = find((sm.post == 125) & (sm.preClass == preClass(i)));
    else
        synInd = find((sm.pre == 125) & (sm.postClass == postClass(i)));
    end
    
    %disp(sprintf('%s %d',imageName, length(synInd)))
    %
    synPos = sm.pos(synInd,dim)/.2 /downSamp;
    synPos = synPos(sum(synPos>1,2)==3,:);
    set(gca,'clipping','off' ), axis off
    
    for b = 1:size(synPos,1);
        bs = bl;
        bs.vertices = bl.vertices + repmat(synPos(b,:),[size(bl.vertices,1) 1])
        renderFV(bs,markerCol(i,:),.5)
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
    
    if i == 3 | i ==6 | i ==9
        
        az = [1:120];
        for a = 1:length(az);
            c = c + 1;
            view([mod(c,360)+startAngle(1) startAngle(2)])
            lightangle(l,mod(c,360)+startAngle(1), startAngle(2)+160)
            
            axis off
            set(gcf,'PaperUnits','points','PaperPosition',[1 1 512 512])
            %runSprings(springDat,allResults{1})
            set(gcf, 'InvertHardCopy', 'off');
            imageName = sprintf('%srot_%05.0f.png',imageDir,c);
            %print(gcf,imageName,'-dpng','-r1024','-opengl','-noui')
            if shouldWrite
                print(gcf, imageName, '-dpng','-opengl','-r248')
            end
            pause(.01)
        end
    end
end

%%



