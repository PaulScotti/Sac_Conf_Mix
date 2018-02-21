% PRESS RIGHT ARROW KEY TO BEGIN
Screen('TextFont', window, 'Helvetica');
Screen('TextSize', window, 30);
startText = 'Is there an error with the eye tracker?\nIf yes, please inform your experimenter.\nIf not, press the RIGHT ARROW key to continue.';
DrawFormattedText(window,startText,'center' ,'center', 0) ;
Screen('flip', window);
begin = 1;
while begin
    [keyIsDown_begin, pressedSecs_begin, keyCode_begin] = KbCheck(keyboardNum);
    if keyIsDown_begin
        beginKey = KbName(find(keyCode_begin));
        TF_begin = strcmp(beginKey, 'RightArrow');
        TF_ET = strcmp(beginKey, 'p');
        if TF_ET == 1
            if ETconnected
                run eyelink_setup;
            end
            Screen('flip', window);
            run startTrigger;
            break;
        end
        if TF_begin == 1
            Screen('flip', window);
            WaitSecs(.5);
            break;
        end
    end
end