close all;
clear all;

warning('off')

load('allPupilData.mat')
startTime = -1;
endTime = 10;

colorRGB = [zeros(1,9)' linspace(0,1,9)' ones(1,9)'];

data = allPupilData{1,1};
x = [startTime:(endTime-startTime)/(size(data.PLR,2)-1):endTime];

subplot(1,3,1);hold on;
plot(x, allPupilData{1,1}.PLR');
title('raw data')
xlabel('time[s]')
ylabel('pupil diameter[mm]')

%% blink interpolation
y = allPupilData{1,1}.PLR;
y = zeroInterp( y, 10, 'pchip');

subplot(1,3,2);hold on;
plot(x, y');
title('interpolated data')
xlabel('time[s]')
ylabel('pupil diameter[mm]')
    
%% pre-processing
% pre_processing(pupil_data, sampling frequency, threshold, window for smoothing, time period of onset and offset)      
[y rejctNum] = pre_processing(y,250, 0.05, 10,[startTime endTime],1,[0.2 35]);
       subplot(1,3,3);hold on;
x = [startTime:(endTime-startTime)/(size(y,2)-1):endTime];
plot(x, y');
title('baseline corrected data')
xlabel('time[s]')
ylabel('pupil changes from baseline [mm]')
