clear all

%% make Stimulus Movie

FRAME_RATE = 60;
SCREEN_WIDTH = 1680;
SCREEN_HEIGHT = 1050;

ISI = 0.5;               % ISI
ISI_FIX = 1;             % ISI
FIX_TIME = 2;            % fixation time
STIM_TIME_BEFORE = 0.05; % Stimulus presentation
STIM_TIME = 0.5;         % Stimulus presentation
STIM_TIME_AFTER = 2;     % Stimulus presentation

rootFolder = '/Users/yuta/Dropbox/MATLAB/P06_MotionIllusion/stim/';
fileList = dir([rootFolder 'flashBar/condition*']);
fileList = fileList(~ismember({fileList.name}, {'.', '..','.DS_Store'}));

fileNameList = {'-83', '-67', '-50', '-33','-17', '0', '17', '33',...
    '_mirror-83', '_mirror-67', '_mirror-50', '_mirror-33','_mirror-17', '_mirror0', '_mirror17', '_mirror33'};

tic
for i = 1:size(fileList,1)
    
    rootFolder2 = [rootFolder 'flashBar/' fileList(i).name];
    fileList2 = dir([rootFolder2 '/*.png']);
    fileList2 = fileList2(~ismember({fileList2.name}, {'.', '..','.DS_Store'}));
    
    file = ['Lag' char(fileNameList(i)) '.avi'];
    writerObj = VideoWriter(file);
    writerObj.FrameRate = FRAME_RATE;
    writerObj.Quality = 100;
    open(writerObj);
    
    %     for i_frame = 1:FIX_TIME*FRAME_RATE
    %         img0 = double(imread([rootFolder 'FIXATION' '/FIXATION.png']))./255;
    %         imshow(img0);
    %         frame = getframe;
    %         writeVideo(writerObj,frame);
    %     end
    %
    %     for i_frame = 1:STIM_TIME_BEFORE*FRAME_RATE
    %         img0 = double(imread([rootFolder 'STIM_TIME_BEFORE' '/STIM_TIME_BEFORE.png']))./255;
    %         imshow(img0);
    %         frame = getframe;
    %         writeVideo(writerObj,frame);
    %     end
    
    for i_frame = 1:size(fileList2,1)
        img0 = double(imread([fileList2(i_frame).folder '/' fileList2(i_frame).name],'png'))./255;
        imshow(img0);
        frame = getframe;
        writeVideo(writerObj,frame);
    end
    
    %     for i_frame = 1:STIM_TIME_AFTER*FRAME_RATE
    %         img0 = double(imread([rootFolder 'ISI' '/ISI.png']))./255;
    %         imshow(img0);
    %         frame = getframe;
    %         writeVideo(writerObj,frame);
    %     end
    %
    %     for i_frame = 1:ISI*FRAME_RATE
    %         img0 = double(imread([rootFolder 'ISI' '/ISI.png']))./255;
    %         imshow(img0);
    %         frame = getframe;
    %         writeVideo(writerObj,frame);
    %     end
    
    close(writerObj);
    toc
    clear writerObj frame
    
end
