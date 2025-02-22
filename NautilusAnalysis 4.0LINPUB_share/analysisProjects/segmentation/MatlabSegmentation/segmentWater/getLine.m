function[outtrack] = getLine();

%% from mousetrack2
set(0, 'units', 'pixels'); 
set(gcf, 'units','pixels'); 
set(gca, 'units','pixels');

set(gca, 'ydir', 'reverse');   % 'normal'  Y axis direction 
  
set(gcf, 'KeyPressFcn',{@keyfig});
set(gcf, 'windowbuttondownfcn', {@starttrack}); 
set(gcf, 'windowbuttonupfcn', {@stoptrack}, 'userdata', []); 
set(gcf, 'Interruptible', 'on'); set(gcf, 'BusyAction', 'queue')    %  queue not loose  actions ...
set(gca, 'Interruptible', 'on'); set(gca, 'BusyAction', 'cancel')
set(gca, 'DrawMode', 'fast') 
set(gca, 'XLimMode', 'manual','YLimMode','manual', 'ZLimMode', 'manual')
set(gcf, 'Renderer', 'painters'); set(gcf, 'DoubleBuffer','on')   % speeds up render, prevents blinking
%set(gcf,'Menubar','none')

waitfor(gca, 'DrawMode','normal') 
outtrack = get(gcf, 'userdata');

function starttrack(imagefig, varargins) 
set(gcf, 'userdata', [] );   % disp('tracking started') 
set(gcf, 'Pointer', 'crosshair') 
%set(gcf, 'windowbuttondownfcn', {@stoptrack}, 'userdata', []);
set(gcf, 'windowbuttonmotionfcn', {@followtrack}); 


function followtrack(imagefig, varargins) 
CurPnt = get(gca, 'CurrentPoint'); 
coords = CurPnt(2,1:2); 
pts = [get(gcf,'userdata'); coords]; 
set(gcf, 'userdata', pts); 
hold on
plot(coords(1), coords(2), 'r.', 'MarkerSize', 10); 
    
hold off


%--------------------------------------------------------------------------
function stoptrack(imagefig, varargins)
set(gcf, 'Pointer', 'arrow')
set(gcf, 'windowbuttonmotionfcn', []);
pts = get(gcf, 'userdata');
set(gca,'DrawMode','normal')


%------------------------------------------------------------------
function keyfig(src,evnt)
    set(gcf,'userdata',evnt)
    set(gca,'DrawMode','normal')


