


%% load
load('MPN.mat')
load('WPN.mat')

load([MPN 'obI.mat'])
load([MPN 'dsObj.mat'])


if exists([MPN 'dat.m'],'file')
    load([MPN 'dat.m'],'file')
else
    dat = [];
end

%% 

tis.colStruc = obI.colStruc;
tis.nameProps = obI.nameProps;
tis.cell = obI.cell;
tis.em = obI.em;


