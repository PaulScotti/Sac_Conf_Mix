% PRESS RIGHT ARROW KEY TO BEGIN
Screen('TextFont', window, 'Helvetica');
Screen('TextSize', window, 35);
startText = 'Good job!\nThe task will continue like this for a few minutes\nand then we will introduce another aspect of the task.\nTry your best to be as fast and as accurate as possible.\nAnd please let us know if you have any questions.';
DrawFormattedText(window,startText,'center' ,'center', 0) ;
Screen('TextSize', window, 30);
continueText = 'Press the RIGHT ARROW key to continue.';
DrawFormattedText(window,continueText,'center' ,rect(4) - 200, 0) ;
Screen('flip', window);
begin = 1;
while begin
    [keyIsDown_begin, pressedSecs_begin, keyCode_begin] = KbCheck(keyboardNum);
    if keyIsDown_begin
        beginKey = KbName(find(keyCode_begin));
        TF_begin = strcmp(beginKey, 'RightArrow');
        if TF_begin == 1
            Screen('flip', window);
            WaitSecs(.5);
            break;
        end
    end
end