if useEyelink
    Eyelink('Message', 'Start_Presentation');
end

count = 1;
for iFlip = 1:60*cfg.PRESENTATION
    
    Screen('CopyWindow', window_s(condition_frame(count)),win);
    Screen('Flip', win,0,1);
    
    imageArray=Screen('GetImage',win);
    if iFlip < 10
        imwrite(imageArray,['test00' num2str(iFlip) '.png']);
    elseif iFlip > 9 && iFlip < 100
        imwrite(imageArray,['test0' num2str(iFlip) '.png']);
    else
        imwrite(imageArray,['test' num2str(iFlip) '.png']);
    end
    
    count = count + 1;
    if count > length(condition_frame)
        count = 1;
    end
    clear keyCode;
    [keyIsDown,secs,keyCode]=KbCheck;
    % interrupt by ESC
    if (keyCode(cfg.KEYNAME.escapeKey))
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
