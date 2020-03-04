function[p] = renderFVbrightBall(fv,col,alph)


p = patch(fv);
view(30,-15);
axis vis3d;
%colormap copper
set(p,'EdgeColor','none');
if exist('col','var')
    p.FaceColor = col;
end
%

daspect([1,1,1])
view(3); axis tight
%camlight
%lighting gouraud


%l = lightangle(145,45) ;
p.FaceLighting = 'gouraud';

p.Clipping = 'off';

if exist('alph','var')
    p.FaceAlpha = alph;

end

set(gca,'color',[0 0 0])
set(gcf,'color',[0 0 0])