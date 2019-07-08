clear all

%% make Stimulus Movie

frame_rate = 60;
stim_time = 3;
SCREEN_WIDTH = 1920;
SCREEN_HEIGHT = 1080;

tic
file = ['stim.avi'];
writerObj = VideoWriter(file);
writerObj.FrameRate = frame_rate;
writerObj.Quality = 100;
open(writerObj);

rootFolder = '/Users/yuta/Dropbox/MATLAB/P05_GlareOscillation/MakeGlareMovie_gradation/';
fileList = dir([rootFolder '*.BMP']);
fileList = fileList(~ismember({fileList.name}, {'.', '..','.DS_Store'}));

for i_frame = 1:size(fileList,1)
img0 = double(imread([fileList(i_frame).folder '/' fileList(i_frame).name],'BMP'))./255;
imshow(img0);
    frame = getframe;
    writeVideo(writerObj,frame);            
end
close(writerObj);
toc
clear writerObj frame
