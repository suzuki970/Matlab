function DrawTrigger( use_trigger, trgNum, win, windowPtr)

if use_trigger==1  % output the trigger
    
    %         if room_num == 1
    %             io32(ioObj, address, 0);
    %         else
    %             outp(address,0);
    %         end
  
        temp = getVPixxTriggerValue(trgNum);
        trg_color = ones(1,1,3);
        trg_color(:,:,1) = temp(1);
        trg_color(:,:,2) = temp(2);
        trg_color(:,:,3) = temp(3);
 
    trg_point = Screen( 'MakeTexture', win, trg_color);
    Screen('DrawTexture', windowPtr, trg_point, [], [0 0 1 1]);
  
    
end

end

