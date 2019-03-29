pointCount = 5;

% Generate an array with coordinates of random points on the display area
rng;
points = rand(pointCount,2);

% Start to collect data
eyetracker.get_gaze_data();

collection_time_s = 2; % seconds

% Cell array to store events
events = cell(2, pointCount);

for i=1:pointCount
    Screen('DrawDots', window, points(i,:).*screen_pixels, dotSizePix, dotColor(2,:), [], 2);
    Screen('Flip', window);
    % Event when startng to show the stimulus
    events{1,i} = {Tobii.get_system_time_stamp, points(i,:)};
    pause(collection_time_s);
    % Event when stopping to show the stimulus
    events{2,i} = {Tobii.get_system_time_stamp, points(i,:)};
end

% Retreive data collected during experiment
collected_gaze_data = eyetracker.get_gaze_data();

eyetracker.stop_gaze_data();