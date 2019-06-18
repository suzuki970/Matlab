function [ y rejctNum] = pre_processing( y,fs, thres, windowL, timeLen, method )

%% ----------------------------------------------------

%% filtering
ave = mean(y,2);
% y = y - repmat(ave,1,size(y,2));
% y = band_filter(y',fs,[0.001 35]);
% y = band_filter(y',fs,[0.01 35]);
y = band_filter(y',fs,[0.1 35]);
y = filter(ones(1,windowL)/windowL, 1, y')';
y = y(:,windowL+1:end);
y = y + repmat(ave,1,size(y,2));

%% baseline(-200ms - 0ms)
startTime = timeLen(1);
endTime = timeLen(2);

x = [startTime:(endTime-startTime)/(size(y,2)-1):endTime];
baselineData = [knnsearch(x',-0.2) knnsearch(x',0)];

if method == 1
    y = y - repmat(median(y(:,baselineData(1):baselineData(2)),2),1,size(y,2));
else
    y = y ./ repmat(median(y(:,baselineData(1):baselineData(2)),2),1,size(y,2));
end

%% reject trials when the velocity of pupil change is larger than threshold
rejctNum = [];
FX = gradient(y);
for j = 1:size(y,1)
    if ~isempty( find(abs(FX(j,baselineData(1):end)) > thres))
        rejctNum = [rejctNum;j];
    end
end

% for j = 1:size(y,1)
%     if ~isempty( find(abs(y(j,baselineData(1):end)) > 0.4))
%         rejctNum = [rejctNum;j];
%     end
% end

for j = 1:size(y,1)
    if sum(isnan(y(j,:))) > 0
        rejctNum = [rejctNum;j];
    end
end

for j = 1:size(y,1)
    if numel(find(y(j,:) == 0)) > size(y,2)/2
        rejctNum = [rejctNum;j];
    end
end

rejctNum = unique(rejctNum);



%% ----------------------------------------------------

end

