function[] = testDraw();

field = uint8(rand(300,300,3)*100);
image(field),pause(.01)

%% from mousetrack2
set(0, 'units', 'pixels'); 
set(gcf, 'units','pixels'); 
set(gca, 'units','pixels');

set(gca, 'ydir', 'reverse');   % 'normal'  Y axis direction 

set(gcf, 'windowbuttondownfcn', {@starttrack}); 
set(gcf, 'windowbuttonupfcn', {@stoptrack}, 'userdata', []); 
set(gcf, 'Interruptible', 'on'); set(gcf, 'BusyAction', 'queue')    %  queue not loose  actions ...
set(gca, 'Interruptible', 'on'); set(gca, 'BusyAction', 'cancel')
set(gca, 'DrawMode', 'fast') 
set(gca, 'XLimMode', 'manual','YLimMode','manual', 'ZLimMode', 'manual')
set(gcf, 'Renderer', 'painters'); set(gcf, 'DoubleBuffer','on')   % speeds up render, prevents blinking
set(gcf,'Menubar','none')


%waitfor(0, 'userdata') 
outtrack = get(0, 'userdata')

function starttrack(imagefig, varargins) 
set(gcf, 'userdata', [] );   % disp('tracking started') 
set(gcf, 'Pointer', 'crosshair') 
%set(gcf, 'windowbuttondownfcn', {@stoptrack}, 'userdata', []);
set(gcf, 'windowbuttonmotionfcn', {@followtrack}); 


function followtrack(imagefig, varargins) 
% global shift ratio
% k = (get(0,'pointerlocation')-shift)*ratio; 
CurPnt = get(gca, 'CurrentPoint'); 
coords = CurPnt(2,1:2); 
pts = [get(gcf,'userdata'); coords]; 
set(gcf, 'userdata', pts); 
hold on
if mod(coords(1),.2) > .1
    plot(coords(1), coords(2), 'b.', 'MarkerSize', 10); 
else
    plot(coords(1), coords(2), 'y.', 'MarkerSize', 10); 
end
hold off


%--------------------------------------------------------------------------
function stoptrack(imagefig, varargins)
set(gcf, 'Pointer', 'arrow')
set(gcf, 'windowbuttonmotionfcn', []);
%set(gcf, 'windowbuttondownfcn', []);  % disp('tracking stopped')
% units0 = get(0, 'units'); unitsf = get(gcf, 'units'); unitsa = get(gca, 'units');                   
%set(0, 'units', units0); set(gcf, 'units', unitsf); set(gca, 'units', unitsa);
%mousetrail = (get(gcf,'userdata') - repmat(shift, size(get(gcf,'userdata'),1),1))*ratio;
pts = get(gcf, 'userdata')
% if (length(pts) > 3)
% %     k = convhull(pts(:,1), pts(:,2)); 
% %     plot(pts(k,1), pts(k,2), '-r'); 
%     set(0,'userdata', pts);
% end









