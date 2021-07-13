function [ y rejctNum] = pre_processing( y,fs, thres, windowL, timeLen, method, filt )

%% filtering
if ~isempty(filt)
    ave = mean(y,2);
    y = y - repmat(ave,1,size(y,2));
    y = band_filter(y',fs,[filt(1) filt(2)]);
    % y = band_filter(y',fs,[0.2 35]);
    y = y + repmat(ave,1,size(y,2));
end

%% Smoothing
y = filter(ones(1,windowL)/windowL, 1, y')';
y = y(:,windowL+1:end);

%% baseline(-200ms - 0ms)
startTime = timeLen(1);
endTime = timeLen(2);

x = [startTime:(endTime-startTime)/(size(y,2)-1):endTime];
baselineData = [knnsearch(x',-0.2) knnsearch(x',0)];

if method == 1
    y = (y - repmat(mean(y(:,baselineData(1):baselineData(2)),2),1,size(y,2)));
elseif method == 2
    y = y ./ repmat(mean(y(:,baselineData(1):baselineData(2)),2),1,size(y,2));
else
    y = (y - repmat(mean(y(:,baselineData(1):baselineData(2)),2),1,size(y,2))) ./ repmat(std(y(:,baselineData(1):baselineData(2))')',1,size(y,2));
end

%% reject trials when the velocity of pupil change is larger than threshold
rejctNum = [];
FX = gradient(y);
for j = 1:size(y,1)
    if ~isempty( find(abs(FX(j,baselineData(1):end)) > thres))
        rejctNum = [rejctNum;j];
    end
end

%% reject trials when the NAN includes
for j = 1:size(y,1)
    if sum(isnan(y(j,:))) > 0
        rejctNum = [rejctNum;j];
    end
end

%% reject trials when number of 0 > 50%
for j = 1:size(y,1)
    if numel(find(y(j,:) == 0)) > size(y,2)/2
        rejctNum = [rejctNum;j];
    end
end

rejctNum = unique(rejctNum);

end

