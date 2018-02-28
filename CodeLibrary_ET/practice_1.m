%% % BASIC SETUP STUFF
% Loop through instructions
directory = pwd;
instrDir=strcat(directory,'/Instruct/');

instrfiles = dir(fullfile(instrDir, ('*.png')));
nfiles = length(instrfiles);    % Number of files found
for i=1:nfiles
   currentfilename = instrfiles(i).name;
   currentimage = imread([instrDir, currentfilename]);
   Instruct{i} = currentimage;
end

% Flip through all instructions 
pageCounter=1;
while pageCounter <= length(instrfiles)
    if pageCounter == 0
        showInstruct = Screen('MakeTexture', window, Instruct{1});
        Screen('DrawTexture', window,showInstruct, [], rect);
        Screen('Flip', window);
        pageCounter = 1;
        WaitSecs(.5);
    elseif pageCounter > length(instrfiles)
        showInstruct = Screen('MakeTexture', window, Instruct{end});
        Screen('DrawTexture', window,showInstruct, [], rect);
        Screen('Flip', window);
        pageCounter = length(instrfiles);
    elseif pageCounter < 1
        showInstruct = Screen('MakeTexture', window, Instruct{1});
        Screen('DrawTexture', window,showInstruct, [], rect);
        Screen('Flip', window);
        pageCounter = 1;
    else
        showInstruct = Screen('MakeTexture', window, Instruct{pageCounter});
        Screen('DrawTexture', window,showInstruct, [], rect);
        Screen('Flip', window);
        WaitSecs(.5);
    end
    
    if pageCounter == length(instrfiles) % if on last page
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
                    pageCounter = length(instrfiles);
                end
                break
            end
        end
        
    end
end

saccadeBank_prac = BalanceFactors(pracTrialNum, 1, [0 1 2 3]); % 0: no sac (50ms), 1: no sac (500 ms), 2: 50 ms, 3: 500 ms
%% TRIAL LOOP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
while trial <= pracTrialNum
    
    %CREATE ET FILE FOR EACH BLOCK
    matETfile_name = ([expt_ID '_s' num2str(subj_num) '_' subj_init '_' num2str(block) '_ET.mat']);
    
    %% Check if got 5 Xs in a row, give notice to check ET
    if ETconnected
        if xTally >= 5
            run PerformanceCheck
            xTally = 0;
        end
    end

    saccade = saccadeBank_prac(trial);

    disp(['Trial ',num2str(trial)]);
    disp(['Cur_Block',num2str(block)]);

    % SETTING UP FIRST FIXATION LOCATION randomly to one of four possible fixation locations
    firstFix = fixations(:, randi(4));

    % PICK SACCADE CUE LOCATION (EITHER HORIZONTAL OR VERTICAL) & LABEL
    if firstFix == A'
        ffPos = 'A';
        if saccade > 1
            newFixation = [B;C]';
        else
            newFixation = [A;A]';
        end
    elseif firstFix == B'
        ffPos = 'B';
        if saccade > 1
            newFixation = [A;D]';
        else
            newFixation = [B;B]';
        end
    elseif firstFix == C'
        ffPos = 'C';
        if saccade > 1
            newFixation = [A;D]';
        else
            newFixation = [C;C]';
        end
    elseif firstFix == D'
        ffPos = 'D';
        if saccade > 1
            newFixation = [B;C]';
        else
            newFixation = [D;D]';
        end   
    end

    disp(['ffPos: ',ffPos]);

    % PICK SECOND FIXATION LOCATION
    newFix = newFixation(:, randi(2));

    % LABEL NEW FIX 
    if newFix' == A
        nfPos = 'A';
    elseif newFix' == B
        nfPos = 'B';
    elseif newFix' == C
        nfPos = 'C';
    elseif newFix' == D
        nfPos = 'D';
    end

    % PICK MEMORY CUE FOR TRIAL, ONE OF THE FOUR POSITIONS
    switch nfPos
        case 'A' 
            memCueLoc{1} = [zOne.center(1)-memCueDim,zOne.center(1)+memCueDim;zOne.center(2)-memCueDim,zOne.center(2)+memCueDim];
            memCueLoc{2} = [zTwo.center(1)-memCueDim,zTwo.center(1)+memCueDim;zTwo.center(2)-memCueDim,zTwo.center(2)+memCueDim];
            memCueLoc{3} = [zFour.center(1)-memCueDim,zFour.center(1)+memCueDim;zFour.center(2)-memCueDim,zFour.center(2)+memCueDim];
            memCueLoc{4} = [zFive.center(1)-memCueDim,zFive.center(1)+memCueDim;zFive.center(2)-memCueDim,zFive.center(2)+memCueDim];
            switch ffPos
                case 'A'
                    position = datasample([2 3 4],1);
                case 'B'
                    position = datasample([2 4],1);
                case 'C'
                    position = datasample([3 4],1);
            end
        case 'B' 
            memCueLoc{1} = [zTwo.center(1)-memCueDim,zTwo.center(1)+memCueDim;zTwo.center(2)-memCueDim,zTwo.center(2)+memCueDim];
            memCueLoc{2} = [zThree.center(1)-memCueDim,zThree.center(1)+memCueDim;zThree.center(2)-memCueDim,zThree.center(2)+memCueDim];
            memCueLoc{3} = [zFive.center(1)-memCueDim,zFive.center(1)+memCueDim;zFive.center(2)-memCueDim,zFive.center(2)+memCueDim];
            memCueLoc{4} = [zSix.center(1)-memCueDim,zSix.center(1)+memCueDim;zSix.center(2)-memCueDim,zSix.center(2)+memCueDim];
            switch ffPos
                case 'A'
                    position = datasample([1 3],1);
                case 'B'
                    position = datasample([1 3 4],1);
                case 'D'
                    position = datasample([3 4],1);
            end
        case 'C' 
            memCueLoc{1} = [zFour.center(1)-memCueDim,zFour.center(1)+memCueDim;zFour.center(2)-memCueDim,zFour.center(2)+memCueDim];
            memCueLoc{2} = [zFive.center(1)-memCueDim,zFive.center(1)+memCueDim;zFive.center(2)-memCueDim,zFive.center(2)+memCueDim];
            memCueLoc{3} = [zSeven.center(1)-memCueDim,zSeven.center(1)+memCueDim;zSeven.center(2)-memCueDim,zSeven.center(2)+memCueDim];
            memCueLoc{4} = [zEight.center(1)-memCueDim,zEight.center(1)+memCueDim;zEight.center(2)-memCueDim,zEight.center(2)+memCueDim];
            switch ffPos
                case 'A'
                    position = datasample([1 2],1);
                case 'C'
                    position = datasample([1 2 4],1);
                case 'D'
                    position = datasample([2 4],1);
            end
        case 'D' 
            memCueLoc{1} = [zFive.center(1)-memCueDim,zFive.center(1)+memCueDim;zFive.center(2)-memCueDim,zFive.center(2)+memCueDim];
            memCueLoc{2} = [zSix.center(1)-memCueDim,zSix.center(1)+memCueDim;zSix.center(2)-memCueDim,zSix.center(2)+memCueDim];
            memCueLoc{3} = [zEight.center(1)-memCueDim,zEight.center(1)+memCueDim;zEight.center(2)-memCueDim,zEight.center(2)+memCueDim];
            memCueLoc{4} = [zNine.center(1)-memCueDim,zNine.center(1)+memCueDim;zNine.center(2)-memCueDim,zNine.center(2)+memCueDim];
            switch ffPos
                case 'B'
                    position = datasample([1 2],1);
                case 'C'
                    position = datasample([1 3],1);
                case 'D'
                    position = datasample([1 2 3],1);
            end
        otherwise
            error('Impossible memory cue position');
    end

    % SET COLORS FOR SQUARES (adjacent colors are -90/90 degrees away, diagonal is 180)
    randcolor = randi(360);
    randCW = BalanceFactors(1,1,[-90 90]);
    texMask = Screen('MakeTexture', window, mask);

    switch position
        case 1
            UL = randcolor;
            UR = within360(randcolor + randCW(1));
            LL = within360(randcolor + randCW(2));
            LR = within360(randcolor + 180);
        case 2 
            UL = within360(randcolor + randCW(1));
            UR = randcolor;
            LL = within360(randcolor + 180);
            LR = within360(randcolor + randCW(2));
        case 3
            UL = within360(randcolor + randCW(1));
            UR = within360(randcolor + 180);
            LL = randcolor;
            LR = within360(randcolor + randCW(2));
        case 4
            UL = within360(randcolor + 180);
            UR = within360(randcolor + randCW(1));
            LL = within360(randcolor + randCW(2));
            LR = randcolor;
    end

    %% PROBE & CUE ECCENTRICITIES RELATIVE TO FF AND NF        
    % Cue center points and distances from fixations
    memCueCenterX = memCueLoc{position}(1) + ((memCueLoc{position}(3) - memCueLoc{position}(1)) / 2);
    memCueCenterY = memCueLoc{position}(2) + ((memCueLoc{position}(4) - memCueLoc{position}(2)) / 2);
    cueDist2ff = abs(sqrt(((firstFix(1) - memCueCenterX) ^ 2) + ((firstFix(2) - memCueCenterY) ^ 2))); % eccentricity between cue and firstFix
    cueDist2nf = abs(sqrt(((newFix(1) - memCueCenterX) ^ 2) + ((newFix(2) - memCueCenterY) ^ 2))); % eccentricity between cue and newFix

    % SET UP "PROBE BOX" FOR EYE TRACKING CHECK (TO ENSURE SUBJECT DIDN'T LOOK AT THE PROBE DURING SACCADE)
    probeBox = memCueLoc{position};

    % SHOW CURRENT TRIAL DETAILS 
    sprintf('Trial = %d\t Condition = %s\n FirstFix = %s\t NewFix = %s\t MemCue = %s\n', trial, num2str(saccade), ffPos, nfPos, num2str(position)) 

    %% START TRIAL
    %Find what time it currently is at start of trial
    trialStartTime = Screen('Flip', window);
    if trial == 1
        blockStartTime = trialStartTime;
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % DRAW AND WAIT FOR INITIAL FIXATION
    Screen('DrawDots', window,firstFix,[fixationSize],white, [0,0], 1);

    drawFixTime = Screen('Flip', window);
    curfx = firstFix(1);
    curfy = firstFix(2);
    FixID = 1; % looking for initial fixation
    run checkFix; %600ms to gain initial fixation
    if runfailed
        xTally = xTally + 1;
        continue
    end

    % FIXATE FOR 1000 MS
    Screen('DrawDots', window,firstFix,[fixationSize],white, [0,0], 1);
    startedFixTimer = Screen('Flip', window);
    staretime = startedFixTimer + 1;
    curfx = firstFix(1);
    curfy = firstFix(2);
    run keepFix;
    if runfailed
        xTally = xTally + 1;
        continue
    end

    % DRAW MEMORY CUE AND REMAIN FIXATED FOR 500 MS
    Screen('DrawDots', window,firstFix,[fixationSize],white, [0,0], 1); 
    Screen('FrameRect', window, [0 0 0], memCueLoc{position}, 4);
    Screen('FrameRect', window, [0 0 0], memCueLoc{position});
    drawMemCueTime = Screen('Flip', window);
    staretime = drawMemCueTime + .5;
    run keepFix;
    if runfailed
        xTally = xTally + 1;
        continue
    end        

    % REMOVE MEMORY CUE AND REMAIN FIXATED (1s)
    Screen('DrawDots', window,firstFix,[fixationSize],white, [0,0], 1);
    remMemCueTime = Screen('Flip', window);
    staretime = remMemCueTime + 1;
    run keepFix;
    if runfailed
        xTally = xTally + 1;
        continue
    end

    % DRAW SACCADE CUE AND RECORD EYES
    Screen('DrawDots', window,newFix,[fixationSize],white, [0,0], 1);
    drawSacTime = Screen('Flip', window);          
    if saccade == 0 || saccade == 2 % 50 ms after saccade end
            disp('50 ms delay');
    elseif saccade == 1 || saccade == 3 % 500 ms after saccade end
            disp('500 ms delay');
    else
            error ('Impossible time bin')
    end
    Delay = 0; cutoff_thresh = 0; % used to determine if trial needs to be cut off (i.e., subject didn't complete a saccade within 600ms)

    staretime = drawSacTime + Delay;
    curfx = newFix(1);
    curfy = newFix(2);
    FixID = 2; % looking for fixation after-saccade cue
    probeEyeCheck = 0;
    look_for_fix = 1; % looking for fixation
    fixdone = 0; % deafult is fixation not complete
    if ETconnected
        if saccade > 1
            run record_eyes_2;
        else
            run keepFix;
            fixdone = 1;
            sac_execution = nan;
            sac_duration = nan;
        end
    end
    if runfailed
        xTally = xTally + 1;
        continue
    end

    % MAKE SURE THEY FIXATE ON NEW LOCATION UNTIL MEMORY TEST
    quitthisloop = 0;
    if ETconnected 
        %set new delays
        switch saccade
            case 0 % no saccade bin
                Delay = .35; %350 ms
            case 1 % no saccade bin
                Delay = .85; %850 ms
            case 2 % retinotopic trace bin
                Delay = .05; %50 ms after new fixation
            case 3 % postSac baseline bin
                Delay = .5; %500 ms after new fixation
        end

        while runfailed == 0  && quitthisloop == 0 %quit loop if took too long to new fixate
            %Wait until they've fixated to new location
            if fixdone == 0
                run record_eyes_2
            elseif fixdone == 1
                waitFixTime = GetSecs; 
                curfx = newFix(1);
                curfy = newFix(2);
                staretime = waitFixTime + Delay;
                FixID = 0;
                run keepFix
                quitthisloop = 1;
            end
        end
    else
        switch saccade
            case 0 % no saccade bin
                Delay = .05 + .35; 
            case 1 % no saccade bin
                Delay = .5 + .35; 
            case 2 % retinotopic trace bin
                Delay = .05 + .35; 
            case 3 % postSac baseline bin
                Delay = .5 + .35;
        end
        WaitSecs(Delay);
        waitFixTime = GetSecs;
    end
    if runfailed
        xTally = xTally + 1;
        continue
    end

    % MEMORY TEST SET-UP
    % redraw new fixation location
    Screen('DrawDots', window,newFix,[fixationSize],white, [0,0], 1);
    % % Setting up random memory test location 
    Screen('FillRect', window, fullcolormatrix(UL,:,:), memCueLoc{1}, 3);
    Screen('FillRect', window, fullcolormatrix(UR,:,:), memCueLoc{2}, 3);
    Screen('FillRect', window, fullcolormatrix(LL,:,:), memCueLoc{3}, 3);
    Screen('FillRect', window, fullcolormatrix(LR,:,:), memCueLoc{4}, 3);
    switch position
        case 1
            testColor = UL;
        case 2
            testColor = UR;
        case 3 
            testColor = LL;
        case 4
            testColor = LR;
    end
    drawMemTest = Screen('flip', window); % time at screen flip / stim presentation

    while drawMemTest > GetSecs() - .05 
        run record_eyes_2;
    end

    % MASK
    Screen('DrawTexture', window, texMask, [], memCueLoc{1});
    Screen('DrawTexture', window, texMask, [], memCueLoc{2});
    Screen('DrawTexture', window, texMask, [], memCueLoc{3});
    Screen('DrawTexture', window, texMask, [], memCueLoc{4});
    drawMasks = Screen('flip', window);

    while drawMasks > GetSecs() - .2
        run record_eyes_2;
    end

    remMasks = Screen('flip', window);
    WaitSecs(.5);

    % CONTINUOUS COLOR RESPONSE
    run colorconfidence

    %% RECORD & SAVE DATA
    run dataRecord;

    % Reset xTally which checks that subj didn't runfail 5 times in a row
    xTally = 0;

    %% END OF TRIAL
    if trial == pracTrialNum
        % save .MAT file
        save (OutputFilePrac, 'Results');
        clear Results probe_start_loc probe_end_loc memCueLoc probeJudgement RT_probe probeAcc absFixEnd sac_duration Delay cutoff_thresh;
        trial = trial+1;
        %Reset eyetracking variables
        et_good_check = 0; et_total_check = 0; et_null_check = 0;
        fixlosscount = 0;
        ma{1} = []; mx{1} = []; my{1} = [];
        matETttrial{1} = []; matETtblock{1} = [];
        WaitSecs(.5); % ITI
    else
        % save .MAT file
        save (OutputFilePrac, 'Results');
        
        trial = trial+1;
        %Reset eyetracking variables
        et_good_check = 0; et_total_check = 0; et_null_check = 0;
        fixlosscount = 0;
        ma{trial} = []; mx{trial} = []; my{trial} = [];
        matETttrial{trial} = []; matETtblock{trial} = [];
        WaitSecs(.5); % ITI
    end
end % end block loop