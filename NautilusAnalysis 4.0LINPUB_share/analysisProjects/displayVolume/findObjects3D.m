clear all
%% Load data
load('MPN.mat')
%MPN = 'D:\LGNs1\Export\export_KV_LIN_morph_2019+3+7K\';

if ~exist('MPN','var')
    MPN = GetMyDir
end

synDir = [MPN 'synPos3\'];
if ~(exist(synDir,'dir')),mkdir(synDir); end

if ~exist('obI','var') | ~exist('dsObj','var')
    disp('loading')
    load([MPN 'obI.mat'])
    load([MPN 'dsObj.mat'])
end

cellList = {125};
subCell = names2Subs(obI,dsObj,cellList);
sub = subCell{1};
    
 scatter3(sub(:,2),sub(:,1),sub(:,3),'.','k')   
 daspect([1 1 1])   
    
    
    
    
    
%% Translate

X = 1855;
Y = 2256;
Z = 642;

YXZdownSamp = 1;


%allPos2 = allPos;
allPos2 = [Y X Z] * YXZdownSamp;

%allPos2(:,3) = fsize(3) - allPos2(:,3);
% dim = viewProps.dim;
% if dim == 1
%     dims = [3 2];
% elseif dim == 2
%     dims = [3 1];
% elseif dim == 3
%     dims = [1 2];
% end

%allPos2 = [1139 843.6  3001];
allPos2 = double(allPos2);
allPos2 = allPos2(:,[1 2 3]) ;
   
dSamp =  (obI.em.res .* [4 4 1])./1000./obI.em.dsRes;
%dSamp = dSamp ./ [4 4 1]; %!!!!!!!!!!!!!!!!!!!!!

allPos2(:,1) = allPos2(:,1)/dSamp(1);
allPos2(:,2) = allPos2(:,2)/dSamp(2);
allPos2(:,3) = allPos2(:,3)/dSamp(3);

allPos2 = round(allPos2);
allPos2(allPos2<1) = 1;


sprintf('%.0f %.0f %.0f',allPos2(end,2),allPos2(end,1),allPos2(end,3))


