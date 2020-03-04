%%Make MPN

% MPN = GetMyDir;
% WPN = GetMyDir;

% CPN = currentDirectory;

% 
MPN =     'J:\Chas VAST Export Data P11 2\';
MPN = 'D:\LGNs1\Export\export_joshm_LIN125_dendType_2018+11+08\'
MPN = 'D:\LGNs1\mergeSeg_mat\';

% WPN =     '..\..\..\joshm\LGNs1\Analysis\';
% MPN = GetMyDir
%WPN = 'J:\Chas VAST Export Data P11 2\';
%WPN = [ MPN 'Analysis\'];
WPN = 'D:\LGNs1\Analysis\'

save('.\MPN.mat','MPN', 'WPN')