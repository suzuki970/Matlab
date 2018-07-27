function [ y,f ] = fftAnalysis(y,fs)

n = length(y);
     y = fft(y,n,2);
    y = abs(y/n);
    f = (0:n-1)*(fs/n);
    
end

