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
ylim([0 6])
title('raw data')
xlabel('time[s]')
ylabel('pupil diameter [mm]')
set( gca, 'FontName','Times','FontSize',16 );
%% blink interpolation
y = allPupilData{1,1}.PLR;

y = zeroInterp( y, 5, 'pchip');

subplot(1,3,2);hold on;
plot(x, y');
ylim([0 6])
title('interpolated data')
xlabel('time[s]')
ylabel('pupil diameter [mm]')
set( gca, 'FontName','Times','FontSize',16 );

%% pre-processing
% pre_processing(pupil_data, sampling frequency, threshold, window for smoothing, time period of onset and offset)
[y rejctNum] = pre_processing(y,250, 0.05, 10,[startTime endTime],1,[]);
subplot(1,3,3);hold on;
x = [startTime:(endTime-startTime)/(size(y,2)-1):endTime];
plot(x, y');
ylim([-2 2])
title('baseline corrected data')
xlabel('time[s]')
ylabel('baseline corrected pupil changes [mm]')
set( gca, 'FontName','Times','FontSize',18 );