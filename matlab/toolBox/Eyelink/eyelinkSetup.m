%% Eye link setup

    % Eyelink Initialization
    % Provide Eyelink with details about the graphics environment
    % and perform some initializations. The information is returned
    % in a structure that also contains useful defaults
    % and control codes (e.g. tracker state bit and Eyelink key values).
    el = EyelinkInitDefaults(win);
    
    % ---
    fprintf('VisualSearch using EyelinkToolbox\n\n\t');
    dummymode=0;       % set to 1 to initialize in dummymode (rather pointless for this example though)
    
    % Initialization of the connection with the Eyelink Gazetracker.
    % exit program if this fails.
    if ~EyelinkInit(dummymode, 1)
        fprintf('Eyelink Init aborted.\n');
        cleanup;  % cleanup function
        return;
    end
    
    [width, height] = Screen('WindowSize', el.window);
    
    [v, vs]=Eyelink('GetTrackerVersion');
    fprintf('Running experiment on a ''%s'' tracker.\n', vs );
    
    % make sure that we get gaze data from the Eyelink
    %     Eyelink('Command', 'link_sample_data = LEFT,RIGHT,GAZE,AREA');
    Eyelink('Command', 'link_sample_data = LEFT,RIGHT,GAZE,AREA,GAZERES,HREF,PUPIL,STATUS,INPUT');
 