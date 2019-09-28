function [TrialRawData] = extractDataFromTXT(i,order,range,dat,TrialRawData)

t0 = dat{1,1}(range); % time stump

%% left eye
t1(:,1) = dat{1,10}(range); % gaze x
t2(:,1) = dat{1,11}(range); % gaze y
t3(:,1) = dat{1,6}(range);% pupil diameter
%% right eye
t1(:,2) = dat{1,12}(range);
t2(:,2) = dat{1,13}(range);
t3(:,2) = dat{1,9}(range);

count=1;
for j = 1:size(t1,1)
    if isempty(strmatch('Message:',t2{j,1}))
        for k = 1:2
            TrialRawData{order,1}(k,i).timeStamp(count) = str2num(t0{j,1});
            TrialRawData{order,1}(k,i).gazeX(count) = str2num(t1{j,k});
            TrialRawData{order,1}(k,i).gazeY(count) = str2num(t2{j,k});
            TrialRawData{order,1}(k,i).diam(count) = str2num(t3{j,k});
        end
         count = count+1;
     end
 end
