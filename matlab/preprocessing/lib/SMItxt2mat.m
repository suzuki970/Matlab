function SMItxt2mat(NAME_EPOCH,rootFolder)


folderList = dir(rootFolder);
folderList = folderList(~ismember({folderList.name}, {'.', '..','.DS_Store'}));
folderList = folderList([folderList.isdir]);

for iSub = 2:size(folderList,1)
    
    f = waitbar(0,'Processing...');
    
    disp(['Analyzing... Subject No.' num2str(iSub)])
    filepath = dir([rootFolder folderList(iSub).name '/*.txt']);
    
    fid = fopen([filepath(1).folder '/' filepath(1).name]);
    dat = textscan(fid,...
        ['%s %s %s %s %s %s %s %s %s %s' ...
        '%s %s %s %s %s %s %s %s %s %s'...
        '%s %s %s %s %s %s %s %s %s %s'...
        '%s %s %s %s %s %s %s %s %s %s'...
        '%s %s %s %s %s %s %s %s %s %s']);
    
    filepath = dir([rootFolder folderList(iSub).name '/*.mat']);
    load([rootFolder folderList(iSub).name '/' filepath(1).name]);
    NumOfconditions = size(condition_frame,2);
    
    %% fixation
    for i = 1:size(NAME_EPOCH,1)
        t = strmatch(NAME_EPOCH{i},dat{1,6});
        ind(i,:) = t(end-NumOfconditions+1:end);
    end
    
    TrialRawData = [];
    for i = 1:NumOfconditions
        waitbar(i/NumOfconditions,f,['Processing...' num2str(i/NumOfconditions*100) '%']);
        for j = 1:size(ind,1)-1
            range = (ind(j,i)+1):(ind(j+1,i)-1);
            TrialRawData = extractDataFromTXT(i,j,range,dat,TrialRawData);
        end
    end
    close(f)
    save([rootFolder folderList(iSub).name '/' filepath(1).name(1:end-4) '_edited'],'TrialRawData', 'condition_frame', 'participantsInfo', 'task_response')
    
end

end

