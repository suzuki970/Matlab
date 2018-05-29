function [ pupilData ] = zeroInterp( pupilData, interval, methods)

for trials = 1:size(pupilData,1)
    
    zeroInd = find(pupilData(trials,:) == 0);
    
    % if there are 0 value in the obtained data
    if length(zeroInd) > 0
        
        %% return if 0 includes in the beginning or ending array
        if zeroInd(1,1) < interval || zeroInd(1,end) > size(pupilData(trials,:),2) - interval
            return;
        else
            
            y = pupilData(trials,:);
            % define the onset and offset of the eye blinks
            diffOnOff = diff(zeroInd);
            diffOnOff=[inf diffOnOff inf];
            count = 1;
            clear datOfblinkCood
            datOfblinkCood = zeros(1,2);
            for i = 2:length(diffOnOff)
                if diffOnOff(i) >= interval && diffOnOff(i-1) >= interval      % oneshot noise
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
                    if datOfblinkCood(i,1) == 0
                        return;
                    end
                end
                
                % for offset
                while (y(datOfblinkCood(i,2)) - y(datOfblinkCood(i,2)+1)) <= 0
                    datOfblinkCood(i,2) = datOfblinkCood(i,2)+1;
                    if datOfblinkCood(i,2) == size(y,2)
                        return;
                    end
                end
            end
            
            for i = 1:size(datOfblinkCood,1)
                onsetArray = datOfblinkCood(i,1);
                offsetArray = datOfblinkCood(i,2);
                
                numX = [onsetArray offsetArray];
                numY = pupilData(trials,numX);
                
                xx = onsetArray:offsetArray;
                yy = interp1(numX,numY,xx,methods);
                
                pupilData(trials,xx) = yy;
            end
        end
    end
end
end
