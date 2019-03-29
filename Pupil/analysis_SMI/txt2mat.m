
close all;
clear all;

%% trigger name
NAME_EPOCH = {
    'fixation.jpg';
%     'beforeOnset.jpg';
%     'stimOnset.jpg';
    'interStim.jpg';
    };

rootFolder = './results/';

folderList = dir(rootFolder);
folderList = folderList(~ismember({folderList.name}, {'.', '..','.DS_Store'}));
folderlist = folderList([folderList.isdir]);

for iSub = 1:size(folderlist,1)
    
    f = waitbar(0,'Processing...');
    
    disp(['Analyzing... Subject No.' num2str(iSub)])
    filepath = dir([rootFolder folderlist(iSub).name '/*.txt']);
    
    fid = fopen([filepath(1).folder '/' filepath(1).name]);
    dat = textscan(fid,...
        ['%s %s %s %s %s %s %s %s %s %s' ...
        '%s %s %s %s %s %s %s %s %s %s'...
        '%s %s %s %s %s %s %s %s %s %s'...
        '%s %s %s %s %s %s %s %s %s %s'...
        '%s %s %s %s %s %s %s %s %s %s']);
      numOfTrials = size( strmatch(NAME_EPOCH{1},dat{1,6}),1);
    
    %% 
    for i = 1:size(NAME_EPOCH,1)
        t = strmatch(NAME_EPOCH{i},dat{1,6});
        ind(i,:) = t(end-numOfTrials+1:end);
    end
    
    TrialRawData = [];
    for i = 1:numOfTrials
        waitbar(i/numOfTrials,f,['Processing...' num2str(i/numOfTrials*100) '%']);
        for j = 1:size(ind,1)-1
            range = (ind(j,i)+1):(ind(j+1,i)-1);
            TrialRawData = extractDataFromTXT(i,j,range,dat,TrialRawData);
        end
    end
    close(f)
    save([rootFolder folderlist(iSub).name '/' filepath(1).name(1:end-4) '_edited'],'TrialRawData')
    
end
