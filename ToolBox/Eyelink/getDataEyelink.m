% check for presence of a new sample update
if Eyelink( 'NewFloatSampleAvailable') > 0
    Res_Flag = 1;
    % get the sample in the form of an event structure
    evt = Eyelink( 'NewestFloatSample');
    if eye_used ~= -1 % do we know which eye to use yet?
        % if we do, get current gaze position from sample
        Eye.x(data_index) = evt.gx(eye_used+1); % +1 as we're accessing MATLAB array
        Eye.y(data_index) = evt.gy(eye_used+1);
        RawData(data_index) = evt;
        data_index = data_index + 1;
        %                     FixPointRawData(FixPointdata_index).progressTime = toc;
        
    else % if we don't, first find eye that's being tracked
        eye_used = Eyelink('EyeAvailable'); % get eye that's tracked
        if eye_used == el.BINOCULAR; % if both eyes are tracked
            eye_used = el.LEFT_EYE; % use left eye
        end
    end
end % if sample available
