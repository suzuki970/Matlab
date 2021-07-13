function fdata = band_filter(data,fs,w)
% N = 4;    
% [b,a] = butter(N,w./(fs),'stop');
% fdata = filtfilt(b,a,data)';

bsFilt = designfilt('bandstopfir','FilterOrder',20, ...
         'CutoffFrequency1',w(1),'CutoffFrequency2',w(2), ...
         'SampleRate',fs);
     fdata = filter(bsFilt,data)';