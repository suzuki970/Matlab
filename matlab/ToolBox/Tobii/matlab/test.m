sca;
close all;
clearvars;


Tobii = genpath('./Tobii'); %SMI folder path
addpath(Tobii);

Screen('Preference', 'SkipSyncTests', 1);

Tobii = EyeTrackingOperations();

eyetracker_address = 'tet-tcp://169.254.5.144';

eyetracker = Tobii.get_eyetracker(eyetracker_address);

if isa(eyetracker,'EyeTracker')
    disp(['Address:',eyetracker.Address]);
    disp(['Name:',eyetracker.Name]);
    disp(['Serial Number:',eyetracker.SerialNumber]);
    disp(['Model:',eyetracker.Model]);
    disp(['Firmware Version:',eyetracker.FirmwareVersion]);
else
    disp('Eye tracker not found!');
end

screens = Screen('Screens');

% So in a situation where we
% have two screens attached to our monitor we will draw to the external
% screen. When only one screen is attached to the monitor we will draw to
% this. For help see: help max
screenNumber = max(screens);

% Define black and white (white will be 1 and black 0). This is because
% luminace values are (in general) defined between 0 and 1.
% For help see: help WhiteIndex and help BlackIndex
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);

% Open an on screen window and color it black.
% For help see: Screen OpenWindow?
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, black);

% Get the size of the on screen window in pixels.
% For help see: Screen WindowSize?
[screenXpixels, screenYpixels] = Screen('WindowSize', window);
screen_pixels = [screenXpixels screenYpixels];

% Get the centre coordinate of the window in pixels
% For help see: help RectCenter
[xCenter, yCenter] = RectCenter(windowRect);

% Enable alpha blending for anti-aliasing
% For help see: Screen BlendFunction?
% Also see: Chapter 6 of the OpenGL programming guide
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

% TrackStatus();
Calibration();
dataCollecting();
sca;