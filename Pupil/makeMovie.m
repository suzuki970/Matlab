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

for i_frame = 1:192
img0 = double(imread(strcat('.\heatMap\heatMap',num2str(i_frame),'.png'),'png'))./255;
imshow(img0);
    frame = getframe;
    writeVideo(writerObj,frame);            
end
close(writerObj);
toc
clear writerObj frame
