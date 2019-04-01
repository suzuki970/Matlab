
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

%% data extraction from txt file
TrialRawData = txt2mat(rootFolder, NAME_EPOCH);

%% make long format data
SAMPLING_RATE = 250; % refresh rate of an eye tracking device
windowL = 10;
TIME_START = -0.2;
TIME_END = 3;

timeStamp = abs(ceil(SAMPLING_RATE * (TIME_END-TIME_START)));
pupilDataAll = [];

folderList = dir(rootFolder);
folderList = folderList(~ismember({folderList.name}, {'.', '..','.DS_Store'}));
folderlist = folderList([folderList.isdir]);

for iSub = 1:size(folderlist,1)
    pupilData = zeros(size(TrialRawData{1,1},2),timeStamp);

    f = waitbar(0,'Processing...');
    
    disp(['Analyzing... Subject No.' num2str(iSub)])
    for i = 1:size(TrialRawData{1,1},2)
        
        t = TrialRawData{1,1}(1,i).diam;
        timebin = TrialRawData{1,1}(1,i).timeStamp;
        
        timebin = timebin - timebin(1);
        timebin = timebin/1000 + (1/SAMPLING_RATE*1000);
        timebin = round(timebin/(1/SAMPLING_RATE*1000));
        
        t(timebin > timeStamp) = [];
        timebin(timebin > timeStamp) = [];
        
        pupilData(i,timebin) = t;
    end
    close(f)
    pupilDataAll = [pupilDataAll;pupilData];
end

pupilDataAll = zeroInterp( pupilDataAll, 5, 'pchip');

[pupilDataAll rejctNum1] = pre_processing(pupilDataAll, SAMPLING_RATE, 0.03, windowL,[TIME_START TIME_END],1);
[pupilDataAll rejctNum2] = rejectBlink_PCA(pupilDataAll);

rejctNum = [rejctNum1;rejctNum2];
pupilDataAll(rejctNum,:)=[];
figure;plot(pupilDataAll')
% save([rootFolder folderlist(iSub).name '/' filepath(1).name(1:end-4) '_trial'],'PLR')
