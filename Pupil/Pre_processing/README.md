
############ description ############

---------まばたきの補間用プログラム--------------
script for interpolation of eye blinks

example)

pupil_data = pupil_data;

interval = 10;

mothod = 'pchip'; % Piecewise Cubic Hermite Interpolating Polynomial : pchip has no overshoots and less oscillation if the data is not smooth.

interpolated_pupil_data = zeroInterp( y, interval, mothod);


---------瞳孔前処理用プログラム---------
script for pre-processing of pupil changes

example)

pupil_data = pupil_data;

interval = 10; % window for detecting eyeblinks

mothod = 'pchip'; % mothod for interpolation

fs = 250 % sampling frequency

threshold = 0.1; % threshold to reject eyeblink by velocity 

windowL = 10; % window for smoothing

[start_time end_time] = [-0.2 10]; % time period of onset and offset

method = 1; % 1 : subtraction, 2 : proportion

[pupil_data rejctNum] =  pre_processing(pupil_data, fs, threshold, windowL, [start_time end_time], method)
