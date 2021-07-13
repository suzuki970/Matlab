% -----------------------------------------------------------------------
%
% (c) Copyright 1997-2017, SensoMotoric Instruments GmbH
%
% Permission  is  hereby granted,  free  of  charge,  to any  person  or
% organization  obtaining  a  copy  of  the  software  and  accompanying
% documentation  covered  by  this  license  (the  "Software")  to  use,
% reproduce,  display, distribute, execute,  and transmit  the Software,
% and  to  prepare derivative  works  of  the  Software, and  to  permit
% third-parties to whom the Software  is furnished to do so, all subject
% to the following:
%
% The  copyright notices  in  the Software  and  this entire  statement,
% including the above license  grant, this restriction and the following
% disclaimer, must be  included in all copies of  the Software, in whole
% or  in part, and  all derivative  works of  the Software,  unless such
% copies   or   derivative   works   are   solely   in   the   form   of
% machine-executable  object   code  generated  by   a  source  language
% processor.
%
% THE  SOFTWARE IS  PROVIDED  "AS  IS", WITHOUT  WARRANTY  OF ANY  KIND,
% EXPRESS OR  IMPLIED, INCLUDING  BUT NOT LIMITED  TO THE  WARRANTIES OF
% MERCHANTABILITY,   FITNESS  FOR  A   PARTICULAR  PURPOSE,   TITLE  AND
% NON-INFRINGEMENT. IN  NO EVENT SHALL  THE COPYRIGHT HOLDERS  OR ANYONE
% DISTRIBUTING  THE  SOFTWARE  BE   LIABLE  FOR  ANY  DAMAGES  OR  OTHER
% LIABILITY, WHETHER  IN CONTRACT, TORT OR OTHERWISE,  ARISING FROM, OUT
% OF OR IN CONNECTION WITH THE  SOFTWARE OR THE USE OR OTHER DEALINGS IN
% THE SOFTWARE.
%
% -----------------------------------------------------------------------
% DataStreaming.m
%
% This script shows how to connect to SMI eye tracking application,
% calibrate the eye tracker and receive numerical eye tracking data in Matlab
%
%
% Author: SMI GmbH
% Compatible version Matlab 7.14 32 bits
%                    Psychtoolbox Version 3.0.11

%% Clear all variables, connections, ...
clear all
clc
warning('off', 'all');

%% Load the iViewX API library and connect to the server
InitAndConnectiViewXAPI

%% Tracking
if connected
    
    disp('Get System Info Data')
    ret_sys = iView.iV_GetSystemInfo(pSystemInfoData);
    
    if (ret_sys == 1 )
        
        disp(pSystemInfoData.Value)
        
    else
        
        msg = 'System Information could not be retrieved';
        disp(msg);
        
    end
    
    %% Calibration
    disp('Calibrate iViewX')
    ret_setCal = iView.iV_SetupCalibration(pCalibrationData);
    
    if (ret_setCal == 1 )
        
        ret_cal = iView.iV_Calibrate();
        
        if (ret_cal == 1 )
            
            disp('Validate Calibration')
            ret_val = iView.iV_Validate();
            
            if (ret_val == 1 )
                
                disp('Show Accuracy')
                ret_acc = iView.iV_GetAccuracy(pAccuracyData, int32(0));
                
                if (ret_acc == 1 )
                    
                    disp(pAccuracyData.Value)
                    
                else
                    
                    msg = 'Accuracy could not be retrieved';
                    disp(msg);
                end
                
            else
                msg = 'Error during validation';
                disp(msg);
                
            end
            
        else
            
            msg = 'Error during calibration';
            disp(msg);
        end
    else
        msg = 'Calibration data could not be set up';
        disp(msg);
    end
    
    %% Get Gaze Samples
    try
        
        for i = 1:1000
            
            ret_sam = iView.iV_GetSample(pSampleData);
            
            if (ret_sam == 1)
                
                Smp = libstruct('SampleStruct', pSampleData);
                msg =	[int2str(i) '  ' int2str(Smp.timestamp) ' - GazeX: ' int2str(Smp.leftEye.gazeX) ' - GazeY: ' int2str(Smp.leftEye.gazeY)];
                disp(msg);
                
            else
                
                msg = 'Unable to get gaze samples';
                disp(msg)
                
            end
            
            pause(0.034);
            
        end
        
    catch ME
        
        msg = 'Unable to get gaze samples';
        disp(msg);
        ME.message
        
    end
    
end

%% Unload the iViewX API library and disconnect from the server
UnloadiViewXAPI






