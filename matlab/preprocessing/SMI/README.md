# Data extraction from txt file on SMI 

txt2mat.m is for data transform from txt to .mat.   
NAME_EPOCH is the name of trigger saved on the file by SMI.  
Transformed data('TrialRawData') will be saved to the same location as the txt file.

example)
```
%% trigger name
NAME_EPOCH = {
    'fixation.jpg';
    'interStim.jpg';
    };
rootFolder = './results/';

%% data extraction from txt file
TrialRawData = txt2mat(rootFolder, NAME_EPOCH);
```
TrialRawData{1,1}(1,1) is eye tracking data of left eye and first trial.  
TrialRawData{1,1}(2,1) is eye tracking data of right eye and first trial.  

    
