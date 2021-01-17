function [ pupilData ] = zeroInterp( pupilData, interval, methods)

for trials = 1:size(pupilData,1)
    
    zeroInd = find(pupilData(trials,:) == 0);
    if length(zeroInd) > size(pupilData,2)/2
        continue;
    end
    
    % if there are 0 value in the obtained data
    if length(zeroInd) > 0
        
        if zeroInd(1,1) == 1 && length(zeroInd) == 1
            pupilData(trials,1) = pupilData(trials,2);
            continue;
        end
        
        if zeroInd(1,1) == size(pupilData,2) && length(zeroInd) == 1
            pupilData(trials,end) = pupilData(trials,end-1);
            continue;
        end
        
        if zeroInd(1,end) == size(pupilData,2) && length(zeroInd) == 1
            continue;
        end
        
        if zeroInd(1,end) == size(pupilData,2) && zeroInd(1,end) ~= zeroInd(1,end-1)+1
            pupilData(trials,end) = pupilData(trials,end-1);
            zeroInd(:,end) = [];
            
        elseif zeroInd(1,end) > size(pupilData,2) - interval
            endFlag = true;
            count = size(zeroInd,2);
            rejInd = [];
            while endFlag
                if count == 1
                    rejInd = [rejInd;count];
                    break;
                end
                if zeroInd(1,count) == zeroInd(1,count-1)+1
                    rejInd = [rejInd;count];
                    count = count-1;
                else
                    rejInd = [rejInd;count];
                    endFlag = false;
                end
                
            end
            zeroInd(:,rejInd) = [];
            %             zeroInd(:,end-interval:end) = [];
        end
    end
    
    if isempty(zeroInd)
        continue;
    end
    
    %
    %% return if 0 includes in the beginning or ending array
    if zeroInd(1,1) < interval
        %             || zeroInd(1,end) > size(pupilData(trials,:),2) - interval
        %             zeroInd(:,1:interval) = [];
        endFlag = true;
        count = 1;
        rejInd = [];
        while endFlag
            if count == size(zeroInd,2)
                break;
            end
            if size(zeroInd,2) == 1
                rejInd = [rejInd;count];
                endFlag = false;
            else
                if zeroInd(1,count) == zeroInd(1,count+1)-1
                    rejInd = [rejInd;count];
                    count = count+1;
                else
                    rejInd = [rejInd;count];
                    endFlag = false;
                end
            end
        end
        zeroInd(:,rejInd) = [];
    end
    
    %     else
    y = pupilData(trials,:);
    % define the onset and offset of the eye blinks
    diffOnOff = diff(zeroInd);
    diffOnOff=[inf diffOnOff inf];
    count = 1;
    %             clear datOfblinkCood
    datOfblinkCood = zeros(1,2);
    for i = 2:length(diffOnOff)
        if diffOnOff(i) >= interval && diffOnOff(i-1) >= interval      % one-shot noise
            datOfblinkCood(count,:) = [zeroInd(i-1) zeroInd(i-1)];
            count = count+1;
        elseif diffOnOff(i) >= interval && diffOnOff(i-1) <= interval  % offset of the blink
            datOfblinkCood(count,2) = zeroInd(i-1);
            count = count+1;
        elseif diffOnOff(i) < interval && diffOnOff(i-1) < interval  % continuing blink
            
        elseif diffOnOff(i) < interval && diffOnOff(i-1) >= interval  % onset of the blink
            datOfblinkCood(count,1)= zeroInd(i-1);
        end
    end
    
    % adjust the onset and offset of the eye blinks
    for i = 1:size(datOfblinkCood,1)
        % for onset
        while (y(datOfblinkCood(i,1)) - y(datOfblinkCood(i,1)-1)) <= 0
            datOfblinkCood(i,1) = datOfblinkCood(i,1)-1;
            if datOfblinkCood(i,1) == 1
                break;
            end
        end
        
        % for offset
        while (y(datOfblinkCood(i,2)) - y(datOfblinkCood(i,2)+1)) <= 0
            datOfblinkCood(i,2) = datOfblinkCood(i,2)+1;
            if datOfblinkCood(i,2) == size(y,2)
                break;
            end
        end
    end
    
    for i = 1:size(datOfblinkCood,1)
        onsetArray = datOfblinkCood(i,1);
        offsetArray = datOfblinkCood(i,2);
        if onsetArray == offsetArray
            %             numX = [onsetArray-1 offsetArray+1];
            %             numY = pupilData(trials,numX);
            %
            %             xx = onsetArray:offsetArray;
            %             yy = interp1(numX,numY,xx,methods);
            numX = [1:(onsetArray-1) (offsetArray+1):size(y,2)];
            numY = pupilData(trials,numX);
            xx = 1:size(y,2);
            yy = interp1(numX,numY,xx,methods);
        else
            %                         numX = [onsetArray offsetArray];
            %                         numY = pupilData(trials,numX);
            %                        xx = onsetArray:offsetArray;
            numX = [1:onsetArray offsetArray:size(y,2)];
            numY = pupilData(trials,numX);
            xx = 1:size(y,2);
            yy = interp1(numX,numY,xx,methods);
        end
        
        pupilData(trials,xx) = yy;
    end
end
%     end
end

