function [ y rejctNum] = pre_processing( y,fs, thres, windowL, timeLen )

%% ----------------------------------------------------

rejctNum = [];
for j = 1:size(y,1)
    if sum(isnan(y(j,:))) > 0
        rejctNum = [rejctNum;j];
    end
end

%% filtering
ave = mean(y,2);
y = y - repmat(ave,1,size(y,2));
y = filter(ones(1,windowL)/windowL, 1, y')';
y = y(:,windowL+1:end);
y = y + repmat(ave,1,size(y,2));

%% baseline(-200ms - 0ms)
startTime = timeLen(1);
endTime = timeLen(2);

x = [startTime:(endTime-startTime)/(size(y,2)-1):endTime];
baselineData = [knnsearch(x',-0.2) knnsearch(x',0.0)];

y = y - repmat(median(y(:,baselineData(1):baselineData(2)),2),1,size(y,2));

%% reject trials when the velocity of pupil change is larger than threshold
FX = gradient(y);
for j = 1:size(y,1)
    if ~isempty( find(abs(FX(j,baselineData(1):end)) > thres))
        rejctNum = [rejctNum;j];
    end
end

rejctNum = unique(rejctNum);
y(rejctNum,:)=[];



%% ----------------------------------------------------

end

