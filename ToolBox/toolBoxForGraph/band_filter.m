function fdata = band_filter(data, f_s, w)
N = 4;    
[b,a] = butter(N,[w(1)/(f_s/2) w(2)/(f_s/2)]);
fdata = filtfilt(b,a,data)';
