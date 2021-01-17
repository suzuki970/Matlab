if useEyelink
    Eyelink('Message', 'Start_Presentation');
end

count = 1;
for iFlip = 1:60*cfg.PRESENTATION
    
    Screen('CopyWindow', window_s(condition_frame(count)),win);
    Screen('Flip', win,0,1);
      
    count = count + 1;
    if count > 60
        count = 1;
    end
    clear keyCode;
    [keyIsDown,secs,keyCode]=KbCheck;
    % interrupt by ESC
    if (keyCode(escapeKey))
        Screen('CloseAll');
        Screen('ClearAll');
        ListenChar(0);
        sca;
        return
    end
end

if useEyelink
    Eyelink('Message', 'End_Presentation');
end
