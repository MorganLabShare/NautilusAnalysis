%% ParseXML for breadCrumbs
clear all
TPN = GetMyDir;

%% Identify Crumb files

cnams = dir([TPN '\crumbs']);
xnams = {};
for i = 1:length(cnams)
    nam = cnams(i).name;
    if length(nam)>3
        if strcmp(nam(end-3:end),'.xml')
            xnams{length(xnams)+1} = nam;
        end
    end
end


%% run all objects

maxs = [1 1 1]; %enter dummy mins maxes
mins = [10^10 10^10 10^10];

for x = 1:length(xnams)
    sprintf('Running object %d of %d',x,length(xnams))
    
    %% open file
    xnam = [TPN '\crumbs\' xnams{x}];
    [fid message] = fopen(xnam);
    rawx = fread(fid);
    fclose(fid);
    charx = char(rawx');

    %% Get values for attributes
    attributes = {'contour section'; 'point x'};

    for a = 1 : length(attributes);
        search1 = attributes{a};
        pos1 = strfind(charx,search1);
        varA = [];
        for i = 1:length(pos1)
            rec = 0; numVar = 1;var1 = [];
            for w = 1:1000;
                c = charx(pos1(i) + length(search1)+ w -1);
                %if (double(c) > 47 ) & ( double(c) <58)
                if rec
                    var1 = [var1 c];
                end

                if c == '"'

                    rec = ~rec; %switch rec
                    if ~rec % if done recording
                        %var1(1:end-1),pause
                        varA(i,numVar) = str2num(var1(1:end-1));
                        numVar = numVar + 1;
                        var1 = [];
                    end

                elseif c == '>'
                    break
                end

            end
        end
        att{a} = varA;
    end % run attributes

%% make possitions for object
    pos = [att{1} att{2}]; %format z x y positions
    mins = min(mins,min(pos,[],1));
    maxs = max(maxs,max(pos,[],1));
    obs{x} = pos;  %record object

end

%% Make planes

planes = cell(maxs(1)+1,1);

for o = 1:length(obs)
   ob = obs{o};
   for i = 1:size(ob,1)
      plane = planes{ob(i,1)+1}; 
      plane = [plane; o ob(i,2:3)];
      planes{ob(i,1)+1} = plane;
   end
end

planes

binCrumb.obs = obs;
bincrumb.planes = planes;
save([TPN 'binCrumb.mat'],'binCrumb')

%% Display result
col = 'rgbcmyk';
for o = 1:30%length(obs)
    ob = obs{o};
    useCol = col(fix(rand *length(col))+1)
    scatter3(ob(:,2),ob(:,3),ob(:,1)*10,useCol,'.')
    hold on
    pause(.01)
    
end

hold off