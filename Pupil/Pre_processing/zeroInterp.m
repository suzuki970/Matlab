function [ pupilData ] = zeroInterp( pupilData, interval, methods)

for trials = 1:size(pupilData,1)
    
    y_base = pupilData(trials,:);
    y_base = y_base(interval:length(y_base));
    
    y = pupilData(trials,:);
    
    if interval > 0
        
        y = filter(ones(1,interval)/interval, 1, y')';
        y = y(:,interval:end);
        
        y(:,find(y < 10^-5)) = 0;
    end
    
    zeroInd = find(y(:,1:end-1) == 0);
    
    %% if there are 0 value in the obtained data
    if length(zeroInd) > 0
        
        %% define the onset and offset of the eye blinks
        diffOnOff = diff(zeroInd);
        diffOnOff=[inf diffOnOff inf];
        count = 1;
       
        datOfblinkCood = zeros(1,2);
        for i = 2:length(diffOnOff)
            if diffOnOff(i) >= interval && diffOnOff(i-1) >= interval     % one-shot noise
                datOfblinkCood(count,:) = [zeroInd(i-1) zeroInd(i-1)];
                count = count+1;
            elseif diffOnOff(i) >= interval && diffOnOff(i-1) <= interval % offset of the blink
                datOfblinkCood(count,2) = zeroInd(i-1);
                count = count+1;
            elseif diffOnOff(i) < interval && diffOnOff(i-1) < interval   % continuing blink
                
            elseif diffOnOff(i) < interval && diffOnOff(i-1) >= interval  % onset of the blink
                datOfblinkCood(count,1)= zeroInd(i-1);
            end
        end
        
        %% adjust the onset and offset of the eye blinks
        for i = 1:size(datOfblinkCood,1)
            % for onset
            while (y(1,datOfblinkCood(i,1)) - y(1,datOfblinkCood(i,1)-1)) <= 0
                datOfblinkCood(i,1) = datOfblinkCood(i,1)-1;
                if datOfblinkCood(i,1) == 1
                    break;
                end
            end
            
            % for offset
            while (y(1,datOfblinkCood(i,2)) - y(1,datOfblinkCood(i,2)+1)) <= 0
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
                y_base(onsetArray)=0;
            else
                y_base(onsetArray:offsetArray)=0;
            end
        end
        
        for i = 1:size(datOfblinkCood,1)
            y = [pupilData(trials,1:interval-1),y_base];
            
            nonZero = find(y ~= 0);
            if length(nonZero) ~= length(y)
                numX = 1:length(y);
                xx = 1:size(y,2);
                yy = interp1(numX(nonZero),pupilData(trials,nonZero),xx,methods);             
                pupilData(trials,:) = yy;
            end

        end
    end
    
end


