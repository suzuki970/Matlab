
############ description ############

---------まばたきの補間用プログラム--------------
script for interpolation of eye blinks

example)

pupil_data = pupil_data;

interval = 10;

mothod = 'pchip';


interpolated_pupil_data = zeroInterp( y, interval, mothod);


---------瞳孔前処理用プログラム---------
script for pre-processing of pupil changes

example)

pupil_data = pupil_data;

interval = 10;

mothod = 'pchip';

fs = sampling frequency, threshold;

windowL = window for smoothing;

time period of onset and offset = [start_time end_time];

[pupil_data rejctNum] =  pre_processing(pupil_data, fs, windowL, )
