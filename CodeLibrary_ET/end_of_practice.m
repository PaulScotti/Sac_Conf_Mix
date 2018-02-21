%% END OF TRIAL SCREEN
Screen('TextFont', window, 'Helvetica');
Screen('TextSize', window, 40);
endOfPrac='This concludes the practice session.\nIf you have any questions, ask your experimenter now.\n\n\n\nWhen you are ready to begin, press the SPACE key';
DrawFormattedText(window,endOfPrac,'center' ,'center', 0) ;
Screen('TextSize', window, 30);

run joker

Screen('flip', window);
begin = 1;
while begin
    [keyIsDown_begin, pressedSecs_begin, keyCode_begin] = KbCheck(keyboardNum);
    if keyIsDown_begin
        beginKey = KbName(find(keyCode_begin));
        TF_begin = strcmp(beginKey, 'space');
        if TF_begin == 1
            Screen('flip', window);
            WaitSecs(.5);
            break;
        end
    end
end