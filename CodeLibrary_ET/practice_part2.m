%% % BASIC SETUP STUFF
maxPracTrials = 50;
correctFix = 0;
% Number of succesful trials per practice part needed in order to move on
correctFixMinP2 = 12;
responded_memTest = [];
grandTrial = 1; 
practicepart2 = 1;


%setting up practice trial types for delay and then position
trialTypeBank = randperm(50);

memoryTestOffset = 105.7694; %easier 3 visual angle to start with

%% % PART 2 INSTRUCTIONS (HORIZONATAL & VERTICAL EYE MOVEMENTS WITH MEMORY TEST)
% Subject needs to correctly make 8 saccades (just as above) while also
% holding the memory cue in memory and doing the memory test

Directory.Instruct2 = [Directory.mainDir, filesep, 'Instruct2_v2'];

% Loop through instructions
practiceInstructionFiles = dir([Directory.Instruct2 filesep 'I*']); % place instruction PNGs into a structure

for page = 1:length(practiceInstructionFiles)
    Instruct{page} = imread([Directory.Instruct2 filesep practiceInstructionFiles(page).name]);
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
pageCounter = 1;
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
        keyNav = [KbName('LeftArrow'), KbName('space'), KbName('escape')];
        while ~any(ismember(keyNav, find(keyCode)));
            [secs, keyCode, deltaSecs] = KbWait([],3);
        end
        
        response = find(keyCode);
        response = response(1);
        responseKey = KbName(response);
        if strcmp (responseKey, 'LeftArrow')
            pageCounter = pageCounter-1;
        elseif strcmp (responseKey, 'space') %
            pageCounter = pageCounter+1;
        elseif strcmpi (responseKey, 'escape')
            break
        end
        %        break
        
    else %not on final page
        
        while (1)
            [keyIsDown, secs, keyCode] = KbCheck(keyboardNum);
            if keyIsDown
                response = find(keyCode);
                response = response(1);
                responseKey = KbName(response);
                if strcmp (responseKey, 'LeftArrow')
                    pageCounter = pageCounter-1;
                elseif strcmp (responseKey, 'RightArrow')
                    pageCounter = pageCounter+1;
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

%% % PART 2 TASK (HORIZONATAL & VERTICAL EYE MOVEMENTS WITH MEMORY TEST)
 for t= 1:40
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
   
    if any(trialType == [1:25])
        control = 0;
        run NS_spatio2
%     elseif any(trialType == [13:16])
%         run predict2;
%     elseif any(trialType == [10:11])
%         run retino2;
    elseif any(trialType == [25:50])
        control = 1;
        run NS_spatioCtrl2;
%     elseif any(trialType == [21:24])
%         run predictCtrl2;
%     elseif any(trialType == [15:16])
%         run retinoCtrl2; 
    end
        
    % Set up memory test Locs
    run memTestLocs;
       
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

        % MEMORY TEST SET-UP
        % % Setting up random memory test location 
        Screen('FrameRect', window, [255 255 0], memoryTestLoc, 3); % RECTANGLE FILLED-IN  
        KeyIsDown_memory = 0;  % Key down starts as False
        stimDuration_memory = 5;% Stim on screen for this amount of time
        responseDuration_memory = 5;% This much time given to make response from stim onset
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
    end
        
    run memoryScore;
    
    if memoryTestJudgement ~= 0
        responded_memTest(t) = memoryAcc;
    else
        responded_memTest(t) = 0;
    end
    
    WaitSecs(1); % 1 second ITI
    
    %No staircase!
      
    if t <= 9 %never count the first 5 trials for figuring out if they finished
        t = t + 1;
        grandTrial = grandTrial + 1;
    elseif mean(responded_memTest(end-4:end)) >= .8
        correctFix = 0;
        scoreProbe = 0;
        clear t;
        memoryTestOffset = initialOffset; 
        responded_memTest = 0;
        practicepart2 = 0;
        break;
    else
        t = t + 1;
        grandTrial = grandTrial + 1;
    end
end

