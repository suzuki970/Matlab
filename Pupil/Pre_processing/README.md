
############ description ############

---------まばたきの補間用プログラム--------------
--------- script for interpolation of eye blinks --------------

pupil_data is N(trial) by time length.


example)
interval = 10;
mothod = 'pchip'; % Piecewise Cubic Hermite Interpolating Polynomial : pchip has no overshoots and less oscillation if the data is not smooth.

interpolated_pupil_data = zeroInterp( pupil_data, interval, mothod);


---------瞳孔前処理用プログラム---------

--------- script for pre-processing of pupil changes ---------

example)

interval = 10; % window for detecting eyeblinks

SAMPLING_RATE = 250 % sampling frequency

THRESHOLD = 0.1; % threshold to reject eyeblink by velocity 

windowL = 10; % window for smoothing

[start_time end_time] = [-1 5]; % time period of onset and offset

mothod = 1; % Besaline correction methods by 1:subtraction / 2:proportion

[pupil_data rejctNum1] = pre_processing(pupil_data, SAMPLING_RATE, THRESHOLD, windowL,[startRecTime endRecTime],1);

[ypupil_datarejctNum2] = rejectBlink_PCA(y); % data rejection based on PCA
