%% % BASIC SETUP STUFF
timeBin = 1;
score = .5;
% maxPracTrials = 40; % max practice trials
correctFix = 0;
% Number of succesful trials per practice part needed in order to move on
maxPracTrials = 48; %24 trials for spatio (50%)
correctFixMinP4 = 20;

responded_memTest = 0;
correctProbe = 0;
grandTrial = 1; 

%setting up practice trial types for delay and then position
trialTypeBank = randperm(48);

%% Quest Setup
tGuess = memoryTestOffset + (2 * stair); %approx mean, from no saccade practice and made a little easier
tGuessSd = stair*6; %approximate sd

pThreshold=0.75; %wants to find threshold where participant gets 75% correct
beta= 3.5;
delta=0.01;
gamma=0.5;
grain = stair;
%range is determined later on manually, since QUEST here requires a single integer

q=QuestCreate(tGuess,tGuessSd,pThreshold,beta,delta,gamma,grain);
q.normalizePdf=1; 

%% % PART 3 TASK (HORIZONATAL & VERTICAL EYE MOVEMENTS WITH PROBE DISCRIMINATION TASK)

Directory.Instruct4 = [Directory.mainDir, filesep, 'InstructableB_nowwitheyes'];

% Loop through instructions
practiceInstructionFiles=dir([Directory.Instruct4 filesep 'I*']); % place instruction PNGs into a structure

for page=1:length(practiceInstructionFiles)
    Instruct{page} = imread([Directory.Instruct4 filesep practiceInstructionFiles(page).name]);
    stimuli{page}.instructprac = Screen('MakeTexture', window, Instruct{page});
end
instructX = size(Instruct{1},2);
instructY = size(Instruct{1},1);
instructRatio = instructX / instructY;

% Resize based on display monitor 
if instructY < screenHeight && instructX < screenWidth
    % don't resize
    newInstructX = instructX;
    newInstructY = instructY;
elseif screenRatio > instructRatio % limiting factor is Y
    newInstructX = round(instructX / (instructY / screenHeight));
    newInstructY = screenHeight;
elseif screenRatio < instructRatio % limiting factor is X 
    newInstructX = screenWidth;
    newInstructY = round(instructY / (instructX / screenWidth));
else % same ratio, but resize 
    newInstructX = screenWidth;
    newInstructY = screenHeight;
end
instructRect = [screenCenterX - (newInstructX / 2), screenCenterY - (newInstructY / 2), screenCenterX + (newInstructX / 2), screenCenterY + (newInstructY / 2)];

% Flip through all instructions 
pageCounter=1;
while pageCounter <= length(practiceInstructionFiles)
    if pageCounter == 0
        Screen('DrawTexture', window,stimuli{1}.instructprac, [], instructRect);
        Screen('Flip', window);
        pageCounter = 1;
        WaitSecs(.5);
    elseif pageCounter > length(practiceInstructionFiles)
        Screen('DrawTexture', window,stimuli{length(practiceInstructionFiles)}.instructprac, [], instructRect);
        Screen('Flip', window);
        pageCounter = length(practiceInstructionFiles);
    elseif pageCounter < 1
        Screen('DrawTexture', window,stimuli{1}.instructprac, [], instructRect);
        Screen('Flip', window);
        pageCounter = 1;
    else
        Screen('DrawTexture', window,stimuli{pageCounter}.instructprac, [], instructRect);
        Screen('Flip', window);
        WaitSecs(.5);
    end
    
    if pageCounter == length(practiceInstructionFiles) % if on last page
        % Right arrow key to start
        keyNav = [KbName('LeftArrow'), KbName('space'),KbName('escape')];
        while ~any(ismember(keyNav, find(keyCode)))
            [secs, keyCode, deltaSecs] = KbWait([],3);
        end
        
        response = find(keyCode);
        response = response(1);
        responseKey = KbName(response);
        if strcmp (responseKey, 'LeftArrow')
            pageCounter = pageCounter - 1;
        elseif strcmp (responseKey, 'space') % push rught arrow to start 
            pageCounter = pageCounter + 1;
        elseif strcmpi (responseKey, 'escape')
            break 
        end
%        break
       
    else %not on final page
        
        while (1)
            [keyIsDown, secs, keyCode]=KbCheck(keyboardNum);
            if keyIsDown
                response = find(keyCode);
                response = response(1);
                responseKey = KbName(response);
                if strcmp (responseKey, 'LeftArrow')
                    pageCounter = pageCounter - 1;
                elseif strcmp (responseKey, 'RightArrow')
                    pageCounter = pageCounter + 1;
                elseif strcmp (responseKey, 'ESCAPE')
                    keyCode = [];
                    pageCounter = length(practiceInstructionFiles);
                end
                break
            end
        end
        
    end
end
WaitSecs(.3);
t = 1;

%% % PART 4 INSTRUCTIONS (ENTIRE TASK)
while t<=maxPracTrials;
    %     for t= 1:40
    [timer stimonset fliptime missed beampos]=Screen('Flip', window);
    trialStartTime=timer;
    
    firstFix=fixations(:, randi(4));
    % Setting saccade target locations based on first fixation location
    if firstFix == A';
            ffPos = 'A';
        newFixation = [B;C]';%Setting up saccade location based on first fixation-->no oblique saccades
    elseif firstFix == B'; 
            ffPos = 'B';
        newFixation = [A;D]';%Setting up saccade location based on first fixation-->no oblique saccades
    elseif firstFix == C';
            ffPos = 'C';
        newFixation = [A;D]';%Setting up saccade location based on first fixation-->no oblique saccades
    elseif firstFix == D';
            ffPos = 'D';
        newFixation = [B;C]';%Setting up saccade location based on first fixation-->no oblique saccades
    end;
    % Pick new fixation location
    newFix = newFixation(:, randi(2));
    %         newFix = B' % For testing specific new fixation location
        % LABEL NEW FIX 
        if newFix' == A;
            nfPos = 'A';
        elseif newFix' == B;
            nfPos = 'B';
        elseif newFix' == C;
            nfPos = 'C';
        elseif newFix' == D;
            nfPos = 'D';
        end
        
    %% 
    % PICK MEMORY CUE FOR TRIAL
        % PICK ONE OF THE FOUR POSITIONS
        position = randi(4);
        % FOR TESTING SPECIFIC POSITION (a b c d)
        %         position = 2;
        
        switch position
            case 1 %a
                pos = 'a';
                memCues = [zOne.cueA; zTwo.cueA; zThree.cueA; zFour.cueA; zFive.cueA; zSix.cueA; zSeven.cueA; zEight.cueA; zNine.cueA];
            case 2 %b
                pos = 'b';
                memCues = [zOne.cueB; zTwo.cueB; zThree.cueB; zFour.cueB; zFive.cueB; zSix.cueB; zSeven.cueB; zEight.cueB; zNine.cueB];
            case 3 %c
                pos = 'c';
                memCues = [zOne.cueC; zTwo.cueC; zThree.cueC; zFour.cueC; zFive.cueC; zSix.cueC; zSeven.cueC; zEight.cueC; zNine.cueC];
            case 4 %d
                pos = 'd';
                memCues = [zOne.cueD; zTwo.cueD; zThree.cueD; zFour.cueD; zFive.cueD; zSix.cueD; zSeven.cueD; zEight.cueD; zNine.cueD];
            otherwise
                error('Impossible memory cue position');
        end
        
        % PICK ONE OF THE NINE ZONES
        zone = randi(9);
        % FOR TESTING SPECIFIC ZONE (1-9) 
%                 zone = 9;
        
        region = num2str(zone);
        memCueLoc = memCues(zone, :);
        memCuePos = strcat(region,pos);
        %%
    trialType = trialTypeBank(t);
    time = randi(3) + 1; %Paul: Since this experiment doesn't use "Before"
    
    setter = randi(2);
    if setter == 1 %timeBin is necessary now for the modified spatio2 and spatio2ctrl files
        timeBin = 1; %remap delay
    else
        timeBin = 3; %post delay
    end
   
    if any(trialType == [1:24])
        control = 0;
        run spatio2
    elseif any(trialType == [33:36])
        run predict2;
    elseif any(trialType == [37:40])
        run retino2;
    elseif any(trialType == [25:32])
        control = 1;
        run spatioCtrl2;
    elseif any(trialType == [41:44])
        control = 1;
        run predictCtrl2;
    elseif any(trialType == [45:48])
        control = 1;
        run retinoCtrl2; 
    end
    
    if existProbe == 1
        % do nothing, carry on
    elseif existProbe == 0
        continue
    else
        error ('Impossible ''existProbe'' status');
    end
    
    % SETUP PROBE LOCATION
    run probeLocs 
        
    % Set up memory test Locs
    run memTestLocs;
    
    % SET UP "PROBE BOX" FOR EYE TRACKING CHECK (TO ENSURE SUBJECT DIDN'T LOOK AT THE PROBE DURING SACCADE)
    if probeTilt == 1 % Right
        probeBoxTL = [probe_start_loc(1) - (2*memCueDim), probe_start_loc(2)];
        probeBoxBR = [probe_end_loc(1) + (2*memCueDim), probe_end_loc(2)];
    elseif probeTilt == 2 % Left
        probeBoxTL = [probe_start_loc(1), probe_start_loc(2)];
        probeBoxBR = [probe_end_loc(1), probe_end_loc(2)];
    end
    % example/layout of imaginary "probe box"
    %    - - - - -      - - - - -
    %   | *       |    |       * |
    %   |   *     |    |     *   |
    %   |     *   |    |   *     |
    %   |       * |    | *       |
    %     - - - -       - - - - -
    probeBoxTLX = probeBoxTL(1);
    probeBoxTLY = probeBoxTL(2);
    probeBoxBRX = probeBoxBR(1);
    probeBoxBRY = probeBoxBR(2);
    
    
    % DRAW AND WAIT FOR INITIAL FIXATION
    Screen('DrawDots', window,firstFix,[10],white, [0,0], 1);
    [timer, stimonset, fliptime, missed, beampos] = Screen('Flip', window);
    firstFixCueTime = timer;
    absfixCuetime(1) = timer;
    if trial == 1
        blockStartTime = timer;
    end
    curfx = firstFix(1);
    curfy = firstFix(2);
    pretrial = 1;
    FixID = 1;
    run checkFix; %600ms to gain fixation
    if runfailed
        continue
    end
    pretrial = 0;
    
    % FIXATE FOR 500 MS
    Screen('DrawDots', window,firstFix,[10],white, [0,0], 1);
    [timer, stimonset, fliptime, missed, beampos] = Screen('Flip', window);
    absfixtime(1) = timer;
    firstFixTime = timer;
    staretime = timer + .5;
    curfx = firstFix(1);
    curfy = firstFix(2);
    allowanswer = 0;
    run keepFix; % must keep fixation for 500ms
    if runfailed
        continue
    end
    
    if time == 2 || time == 3 || time == 4; % after sacc
        %     DRAW MEMORY CUE AND REMAIN FIXATED FOR 200 MS
        Screen('DrawDots', window,firstFix,[10],white, [0,0], 1);
        Screen('FrameRect', window, [0 0 0], memCueLoc, 5);
        Screen('FrameRect', window, [0 0 0], memCueLoc);
        [timer, stimonset, fliptime, missed, beampos] = Screen('Flip', window);
        memCueTime = timer;
        absmemcuetime(1) = timer;
        staretime = timer + .2;
        allowanswer = 0;
        run keepFix;
        if runfailed
            correctFix = correctFix + 0;
            continue
        end
        
        %     REMOVE MEMORY CUE AND REMAIN FIXATED FOR 500 MS
        Screen('DrawDots', window,firstFix,[10],white, [0,0], 1);
        [timer, stimonset, fliptime, missed, beampos] = Screen('Flip', window);
        removeMemCueTime = timer;
        absremovecuetime(1) = timer;
        staretime = timer + .5;
        allowanswer = 0;
        run keepFix; 
        if runfailed
            correctFix = correctFix + 0;
            continue
        end
        
        %     DRAW SACCADE CUE AND RECORD EYES
        Screen('DrawDots', window,newFix,[10],white, [0,0], 1);
        [timer, stimonset, fliptime, missed beampos] = Screen('Flip', window);
        abssaccuetime(1) = timer;
        newFixTime = timer;
        newFixCueTime = timer;
        maxDelay = ceil((.7 / monitorFlipInterval)); % refresh rate for testing room monitors is different than lab monitors
        randomFlipSpeed = randi(maxDelay); % random flip in the next 700 ms  (700/monitor flip interval=random flip speed)
        Delay = (randomFlipSpeed * monitorFlipInterval);
        staretime = timer + Delay;
        allowanswer = 0;
        curfx = newFix(1);
        curfy = newFix(2);
        FixID = 2;
        fixdone = 0; % is this necessary?
        probeEyeCheck = 0;
        look_for_fix = 1;
        cutoff_thresh = Delay; % used to determine if trial needs to be cut off (i.e., subject didn't complete a saccade within 600ms)
        run record_eyes;
        if runfailed
            continue
        end
        
        % Draw probe at a random time while still fixating
        Screen('DrawDots', window,newFix,[10],white, [0,0], 1);
        if testingRoom == 1
            Screen('DrawLines', window, [probe_start_loc,probe_end_loc], 7, black,[0,0] ,2);
        else
            Screen('DrawLines', window, [probe_start_loc,probe_end_loc], 7, black,[0,0] ,0);
        end
        keyIsDown_probe = 0; % Key down starts as False
        probeDuration = .1; % 200 ms % Stim on screen for this amount of time
        responseDuration_probe = 1.5; % This much time given to make response from stim onset, based off of original paper's raw RTs
        Left_Right_Key = 0; % default L/R response is 0 (aka no response or incorrect)
        probeJudgement = 0; % default 0
        RT_probe = 0 ; % default
        %             [timer1 stimonset fliptime missed beampos]= Screen('Flip', window, (timer+(randomFlipSpeed*monitorFlipInterval)), 0, 1,0); % time at screen flip / stim presentation
        [timer1 stimonset fliptime missed beampos] = Screen('Flip', window); % time at screen flip / stim presentation
        probeTime = timer1;
        absprobetime(1) = probeTime;
        curfx = newFix(1);
        curfy = newFix(2);
        staretime = probeTime + .2;
        probeDelay = probeTime - timer;
        allowanswer = 1;
        cutoff_thresh = Delay + .2; % used to determine if trial needs to be cut off (i.e., subject didn't complete a saccade within 600ms) 
        if fixdone == 1
            FixID = 0;
            run keepFix;
        elseif fixdone == 0
            look_for_fix = 1;
            FixID = 2;
            probeEyeCheck = 1;
            run record_eyes;
        end
        if runfailed
            continue
        end
        
        % REMOVE PROBE AND RECORD EYES FOR REMAINDER OF RESPONSE DURATION
        Screen('DrawDots', window,newFix,[10],white, [0,0], 1);
        [timer1, stimonset, fliptime, missed, beampos] = Screen('Flip', window); % time at screen flip / stim presentation
        removeProbeTime = timer1;
        staretime = timer1 + responseDuration_probe - probeDuration;
        allowanswer = 1;
        increment_fix_vars = 0;
        probeEyeCheck = 0;
        % probeEyeCheck = 1;
        cutoff_thresh = Delay+.2 + responseDuration_probe - probeDuration; % used to determine if trial needs to be cut off (i.e., subject didn't complete a saccade within 600ms) 
        if fixdone == 0
            look_for_fix = 1;
            FixID = 2;
            run record_eyes;
        elseif fixdone == 1
            increment_fix_vars = 0; %fixation & tracking no longer active for failure purposes; still recording
            look_for_fix = 0;
            FixID = 0;
            run keepFix; 
        end
        if runfailed
            continue
        else
            correctFix = correctFix + 1;
        end
         
        
       % MEMORY TEST SET-UP
        % % Setting up random memory test location 
        Screen('FrameRect', window, [255 255 0], memoryTestLoc, 3);
        KeyIsDown_memory = 0;  % Key down starts as False
        stimDuration_memory = 1.5;% Stim on screen for this amount of time
        responseDuration_memory = 1.5;% This much time given to make response from stim onset
        memoryTestJudgement = 0; % default 0
        Same_Diff_Key = 0;% default S/D response is 0 (aka no response or incorrect)
        RT_memory = 0; % default
        memoryTest = Screen('flip', window); % time at screen flip / stim presentation
        while GetSecs() <= memoryTest + responseDuration_memory %When key down is not False (aka key is IS DOWN)
            [keyIsDown_memory, pressedSecs_memory, keyCode_memory] = KbCheck(keyboardNum); %Yield keyisdown as true, secconds at pressed, and keycode
            if keyIsDown_memory
                Same_Diff_Key = KbName(find(keyCode_memory)); %find name of key that corresponds to keycode pressed
                RT_memory = pressedSecs_memory - memoryTest; %RT is the time which the button was pressed in relation to start time
                TF_same = strcmp(Same_Diff_Key, 's');
                TF_diff = strcmp(Same_Diff_Key, 'd');
                if TF_same == 1 
                    memoryTestJudgement = 1;
                elseif TF_diff == 1  
                    memoryTestJudgement = 2;
                else
                    memoryTestJudgement = 0;
                end
                break;
            end
        end
        
        % Get probe tilt accuracy
        if (probeTilt == 1) && probeJudgement == 2; %left tilt, incorrect response
            probeAcc = 0; Beeper(400, 1, .1);
            correctProbeCount = correctProbeCount + 0;
            scoreProbe = correctProbeCount / t;
        elseif (probeTilt == 1) && probeJudgement == 1; %left tilt, correct response
            probeAcc = 1; Beeper(1000, .8, .1);
            correctProbeCount = correctProbeCount + 1; 
            scoreProbe = correctProbeCount / t;
        elseif (probeTilt == 1) && probeJudgement == 0; %left tilt, no response
            probeAcc = 0; Beeper(400, 1, .1);
            correctProbeCount = correctProbeCount + 0;
            scoreProbe = correctProbeCount / t;
        elseif (probeTilt == 2) && probeJudgement == 2; %right tilt, correct response
            probeAcc = 1; Beeper(1000, .8, .1);
            correctProbeCount = correctProbeCount + 1;
            scoreProbe = correctProbeCount / t;
        elseif (probeTilt == 2) && probeJudgement == 1; %right tilt, incorrect response
            probeAcc = 0; Beeper(400, 1, .1);
            correctProbeCount = correctProbeCount + 0;
            scoreProbe = correctProbeCount / t;
        elseif (probeTilt == 2) && probeJudgement == 0; %right tilt, no response
            probeAcc = 0; Beeper(400, 1, .1);
            correctProbeCount = correctProbeCount + 0; 
            scoreProbe = correctProbeCount / t;
        end
        %give time for beep to occur before memory beep
        if probeAcc == 1
            WaitSecs(.15); 
        elseif probeAcc == 0
            WaitSecs(.5);
        end
        
        run memoryScore; 
        
    elseif time == 1; % before sacc
        %     DRAW MEMORY CUE AND REMAIN FIXATED FOR 200 MS
        Screen('DrawDots', window,firstFix,[10],white, [0,0], 1);
        Screen('FrameRect', window, [0 0 0], memCueLoc, 5);
        Screen('FrameRect', window, [0 0 0], memCueLoc);
        [timer, stimonset, fliptime, missed, beampos] = Screen('Flip', window);
        memCueTime = timer;
        absmemcuetime(1) = timer; 
        staretime = timer + .2;
        allowanswer = 0;
        run keepFix; % must keep fixation for 200ms
        if runfailed
            correctFix = correctFix + 0;
            continue
        end
        
        %     REMOVE MEMORY CUE AND REMAIN FIXATED FOR 200 MS
        Screen('DrawDots', window,firstFix,[10],white, [0,0], 1);
        [timer, stimonset, fliptime, missed, beampos] = Screen('Flip', window);
        removeMemCueTime = timer;
        absremovecuetime(1) = timer;
        staretime = timer + .2;
        allowanswer = 0;
        run keepFix; % must keep fixation for 200ms
        if runfailed
            correctFix = correctFix + 0;
            continue
        end
        
        %     RANDOM PROBE DELAY (REMAIN FIXATED FOR VARIABLE TIME BETWEEN 0 AND 300 MS)
        Screen('DrawDots', window,firstFix,[10],white, [0,0], 1);
        [timer stimonset fliptime missed beampos] = Screen('Flip', window);
        absfixtime(1) = timer;
        extraFixTime = timer;
        maxDelay = (ceil(.3 / monitorFlipInterval));% refresh rate for testing room monitors is different than lab monitors
        randomFlipSpeed = randi(maxDelay); % random flip in the next 300 ms
        Delay = (randomFlipSpeed * monitorFlipInterval);
        staretime = timer + (Delay);
        curfx = firstFix(1);
        curfy = firstFix(2);
        allowanswer = 0;
        run keepFix; % must keep fixation for variable amount of time (between 0 and 300ms)
        if runfailed
            correctFix = correctFix + 0;
            continue
        end
        
        %     DRAW PROBE WHILE REMAINING FIXATED FOR 200 MS
        Screen('DrawDots', window,firstFix,[10],white, [0,0], 1);
        Screen('DrawLines', window, [probe_start_loc,probe_end_loc], 5, black,[0,0] ,0); 
        keyIsDown_probe = 0; % Key down starts as False
        probeDuration = .1; % 200 ms % Stim on screen for this amount of time
        responseDuration_probe = 1.5; % This much time given to make response from stim onset, based off of original paper's raw RTs
        Left_Right_Key = 0; % default L/R response is 0 (aka no response or incorrect)
        probeJudgement = 0; % default 0
        RT_probe = 0 ; % default
        %             [timer1 stimonset fliptime missed beampos]= Screen('Flip', window, (timer+(randomFlipSpeed*monitorFlipInterval)), 0, 1,0); % time at screen flip / stim presentation
        [timer1 stimonset fliptime missed beampos] = Screen('Flip', window); % time at screen flip / stim presentation
        probeTime = timer1;
        absprobetime(1) = probeTime;
        curfx = firstFix(1);
        curfy = firstFix(2);
        staretime = probeTime + .2;
        probeDelay = probeTime - timer;
        allowanswer = 1;
        run keepFix; % must keep fixation for 200ms
        if runfailed
            correctFix = correctFix + 0;
            continue
        end
        
        %     REMOVE PROBE AND REMAIN FIXATED FOR REMAINDER OF RESPONSE DURATION
        Screen('DrawDots', window,firstFix,[10],white, [0,0], 1);
        [timer1, stimonset, fliptime, missed, beampos] = Screen('Flip', window); % time at screen flip / stim presentation
        removeProbeTime = timer1;
        staretime = timer1 + responseDuration_probe - probeDuration;
        allowanswer = 1;
        increment_fix_vars = 0;
        probeEyeCheck = 0;
        % probeEyeCheck = 1;
        FixID = 0;
        look_for_fix = 0;
        cutoff_thresh = 0;
%         run record_eyes;  % record eyes while participant makes a response
        run keepFix; % ???? can subjects respond without looking down at keyboard?
        if runfailed
            continue
        end
            
        %     DRAW SACCADE CUE AND WAIT UNTIL FIXATION ACQUIRED
        Screen('DrawDots', window,newFix,[10],white, [0,0], 1);
        [timer, stimonset, fliptime, missed, beampos] = Screen('Flip', window);
        newFixCueTime = timer;
        abssaccuetime(1) = timer;
        curfx = newFix(1);
        curfy = newFix(2);
        FixID = 2;
        run checkFix; %600ms to gain fixation at new location
        if runfailed
            continue
        end
        
        %     KEEP FIXATED FOR ANOTHER 500 MS
        Screen('DrawDots', window,newFix,[10],white, [0,0], 1);
        [timer, stimonset, fliptime, missed, beampos] = Screen('Flip', window);
        abssactime(1) = timer;
        newFixTime = timer;
        curfx = newFix(1);
        curfy = newFix(2);
        staretime = timer + .5;
        allowanswer = 0;
        run keepFix; % must keep fixation for 500ms
        if runfailed
            correctFix = correctFix + 0;
            continue
        else 
            correctFix = correctFix + 1;
        end  
        
        %     MEMORY TEST SET-UP
        %     Setting up random memory test location
        Screen('FrameRect', window, [0 0 0], memoryTestLoc, 4);
        %     Setting up '?' text
        Screen('TextFont', window, 'Helvetica');
        %     ? size depends on memory cue size
        textSize = floor(60 * (memCueDim/35));
        Screen('TextSize', window, textSize);
        Screen('DrawText',window,'?', questionX, questionY, [0 0 0]) ;
        Screen('FrameRect', window, [0 0 0], memoryTestLoc); % RECTANGLE FILLED-IN  
        Screen('DrawText',window,'?', questionX, questionY, white) ; % RECTANGLE FILLED-IN 
        KeyIsDown_memory = 0;  % Key down starts as False
        stimDuration_memory = 1.5;% Stim on screen for this amount of time
        responseDuration_memory = 1.5;% This much time given to make response from stim onset
        memoryTestJudgement = 0; % default 0
        Same_Diff_Key = 0;% default S/D response is 0 (aka no response or incorrect)
        RT_memory = 0; % default
        memoryTest = Screen('flip', window); % time at screen flip / stim presentation
        while GetSecs() <= memoryTest + responseDuration_memory %When key down is not False (aka key is IS DOWN)
            [keyIsDown_memory, pressedSecs_memory, keyCode_memory] = KbCheck(keyboardNum); %Yield keyisdown as true, secconds at pressed, and keycode
            if keyIsDown_memory
                Same_Diff_Key = KbName(find(keyCode_memory)); %find name of key that corresponds to keycode pressed
                RT_memory = pressedSecs_memory-memoryTest; %RT is the time which the button was pressed in relation to start time
                TF_same = strcmp(Same_Diff_Key, 's');
                TF_diff = strcmp(Same_Diff_Key, 'd');
                if TF_same == 1 
                    memoryTestJudgement = 1;
                elseif TF_diff == 1  
                    memoryTestJudgement = 2;
                else
                    memoryTestJudgement = 0;
                end
                break;
            end
        end
        % Get probe tilt accuracy
        if (probeTilt == 1) && probeJudgement == 2; %left tilt, incorrect response
            probeAcc = 0; Beeper(400, 1, .1);
            correctProbeCount = correctProbeCount + 0;
            scoreProbe = correctProbeCount / t;
        elseif (probeTilt == 1) && probeJudgement == 1; %left tilt, correct response
            probeAcc = 1; Beeper(1000, .8, .1);
            correctProbeCount = correctProbeCount + 1; 
            scoreProbe = correctProbeCount / t;
        elseif (probeTilt == 1) && probeJudgement == 0; %left tilt, no response
            probeAcc = 0; Beeper(400, 1, .1);
            correctProbeCount = correctProbeCount + 0;
            scoreProbe = correctProbeCount / t;
        elseif (probeTilt == 2) && probeJudgement == 2; %right tilt, correct response
            probeAcc = 1; Beeper(1000, .8, .1);
            correctProbeCount = correctProbeCount + 1;
            scoreProbe = correctProbeCount / t;
        elseif (probeTilt == 2) && probeJudgement == 1; %right tilt, incorrect response
            probeAcc = 0; Beeper(400, 1, .1);
            correctProbeCount = correctProbeCount + 0;
            scoreProbe = correctProbeCount / t;
        elseif (probeTilt == 2) && probeJudgement == 0; %right tilt, no response
            probeAcc = 0; Beeper(400, 1, .1);
            correctProbeCount = correctProbeCount + 0; 
            scoreProbe = correctProbeCount / t;
        end
        %give time for beep to occur before memory beep
        if probeAcc == 1
            WaitSecs(.15); 
        elseif probeAcc == 0
            WaitSecs(.5);
        end
        
        run memoryScore;  
    end
    
    if memoryTestJudgement ~= 0
        responded_memTest(t) = memoryAcc
    else
        responded_memTest(t) = 0
    end
    
    run dataRecord;
    
    %QUEST STAIRCASE
    if memoryAcc ~= -1 %don't update staircase if invalid or no response
        % QUEST STAIRCASE: Change memoryTestOffset based on performance of previous trials 
        % Get recommended level.  Choose your favorite algorithm.
        tTest=QuestQuantile(q);	% Recommended by Pelli (1987), and still our favorite.

        % Simulate a trial
        fprintf('Trial %3d at %5.2f is %.0f\n',grandTrial,tTest,memoryAcc);

        % Update the pdf
        q=QuestUpdate(q,tTest,memoryAcc); % Add the new datum (actual test intensity and observer response) to the database.

        % Ask Quest for the final estimate of threshold.
        memoryTestOffset=QuestMean(q);		% Recommended by Pelli (1989) and King-Smith et al. (1994). Still our favorite.
    end
%     if memoryTestOffset < minOffset 
%         memoryTestOffset = minOffset;
%     elseif memoryTestOffset > maxOffset
%         memoryTestOffset = maxOffset; 
%     end 
        
    % ITI 
    if session == 1
        WaitSecs(.9);  
    elseif session >= 2
        WaitSecs(.75);  
    end
    
    if t == maxPracTrials
        save (OutputFile3, 'Results');
        correctFix = 0;
        clear t;
        clear score;
        clear probe_start_loc;
        clear probe_end_loc;
        clear probeJudgement;
        clear RT_probe;
        clear probeAcc;
%       Reset eyetracking variables
        et_good_check = 0;
        et_total_check = 0;
        et_null_check = 0;
        fixlosscount = 0;
        mx = [];
        my = [];
        ma = [];
        matETttrial = [];
        matETtblock = [];
        ma{trial} = [];
        mx{trial} = [];
        my{trial} = [];
        matETttrial{trial} = [];
        matETtblock{trial} = [];      
        break;
    else
        t = t + 1;
        grandTrial = grandTrial + 1;
    end
end

