%% START SCREEN %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Resetting gt if necessary after practice
grandTrial = 1; 

%% TRIAL LOOP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
while block <= numBlocks %first session ends after 3 blocks out of 8 total
    trial = 1;
    
    %CREATE ET FILE FOR EACH BLOCK
    matETfile_name = ([expt_ID '_s' num2str(subj_num) '_' subj_init '_' num2str(block) '_ET.mat']);
    
    % PRESS RIGHT ARROW KEY TO BEGIN
    run startTrigger
    
    while trial <= trialsPerBlock
        %% Check if got 5 Xs in a row, give notice to check ET
        if ETconnected
            if xTally >= 5
                run PerformanceCheck
                xTally = 0;
            end
        end
        
        saccade = saccadeBank(grandTrial);
        
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
                        retino = position;
                    case 'B'
                        position = datasample([2 4],1);
                        if position == 2
                            retino = 1;
                        elseif position == 4
                            retino = 3;
                        end
                    case 'C'
                        position = datasample([3 4],1);
                        if position == 3
                            retino = 1;
                        elseif position == 4
                            retino = 2;
                        end
                end
            case 'B' 
                memCueLoc{1} = [zTwo.center(1)-memCueDim,zTwo.center(1)+memCueDim;zTwo.center(2)-memCueDim,zTwo.center(2)+memCueDim];
                memCueLoc{2} = [zThree.center(1)-memCueDim,zThree.center(1)+memCueDim;zThree.center(2)-memCueDim,zThree.center(2)+memCueDim];
                memCueLoc{3} = [zFive.center(1)-memCueDim,zFive.center(1)+memCueDim;zFive.center(2)-memCueDim,zFive.center(2)+memCueDim];
                memCueLoc{4} = [zSix.center(1)-memCueDim,zSix.center(1)+memCueDim;zSix.center(2)-memCueDim,zSix.center(2)+memCueDim];
                switch ffPos
                    case 'A'
                        position = datasample([1 3],1);
                        if position == 1
                            retino = 2;
                        elseif position == 3
                            retino = 4;
                        end
                    case 'B'
                        position = datasample([1 3 4],1);
                        retino = position;
                    case 'D'
                        position = datasample([3 4],1);
                        if position == 3
                            retino = 1;
                        elseif position == 4
                            retino = 2;
                        end
                end
            case 'C' 
                memCueLoc{1} = [zFour.center(1)-memCueDim,zFour.center(1)+memCueDim;zFour.center(2)-memCueDim,zFour.center(2)+memCueDim];
                memCueLoc{2} = [zFive.center(1)-memCueDim,zFive.center(1)+memCueDim;zFive.center(2)-memCueDim,zFive.center(2)+memCueDim];
                memCueLoc{3} = [zSeven.center(1)-memCueDim,zSeven.center(1)+memCueDim;zSeven.center(2)-memCueDim,zSeven.center(2)+memCueDim];
                memCueLoc{4} = [zEight.center(1)-memCueDim,zEight.center(1)+memCueDim;zEight.center(2)-memCueDim,zEight.center(2)+memCueDim];
                switch ffPos
                    case 'A'
                        position = datasample([1 2],1);
                        if position == 1
                            retino = 2;
                        elseif position == 2
                            retino = 4;
                        end
                    case 'C'
                        position = datasample([1 2 4],1);
                        retino = position;
                    case 'D'
                        position = datasample([2 4],1);
                        if position == 2
                            retino = 1;
                        elseif position == 4
                            retino = 3;
                        end
                end
            case 'D' 
                memCueLoc{1} = [zFive.center(1)-memCueDim,zFive.center(1)+memCueDim;zFive.center(2)-memCueDim,zFive.center(2)+memCueDim];
                memCueLoc{2} = [zSix.center(1)-memCueDim,zSix.center(1)+memCueDim;zSix.center(2)-memCueDim,zSix.center(2)+memCueDim];
                memCueLoc{3} = [zEight.center(1)-memCueDim,zEight.center(1)+memCueDim;zEight.center(2)-memCueDim,zEight.center(2)+memCueDim];
                memCueLoc{4} = [zNine.center(1)-memCueDim,zNine.center(1)+memCueDim;zNine.center(2)-memCueDim,zNine.center(2)+memCueDim];
                switch ffPos
                    case 'B'
                        position = datasample([1 2],1);
                        if position == 1
                            retino = 3;
                        elseif position == 2
                            retino = 4;
                        end
                    case 'C'
                        position = datasample([1 3],1);
                        if position == 1
                            retino = 2;
                        elseif position == 3
                            retino = 4;
                        end
                    case 'D'
                        position = datasample([1 2 3],1);
                        retino = position;
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

        staretime = drawSacTime + Delay - monitorFlipInterval;
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
                    staretime = waitFixTime + Delay - monitorFlipInterval;
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
            WaitSecs(Delay-monitorFlipInterval);
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
        
        while drawMemTest > GetSecs() - .05 - monitorFlipInterval
            run record_eyes_2;
        end
        
        % MASK
        Screen('DrawTexture', window, texMask, [], memCueLoc{1});
        Screen('DrawTexture', window, texMask, [], memCueLoc{2});
        Screen('DrawTexture', window, texMask, [], memCueLoc{3});
        Screen('DrawTexture', window, texMask, [], memCueLoc{4});
        drawMasks = Screen('flip', window);

        while drawMasks > GetSecs() - .2 - monitorFlipInterval
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
        
        %% END OF EXPERIMENT, END OF BLOCK, END OF TRIAL
        if trial == trialsPerBlock
            %             sprintf(' before= %d\t after= %d\n space= %d\t spaceC= %d\t pr= %d\t prC=%d\t retino=%d\t retinoC=%d\n', beforeCount, afterCount,spaceCount, spaceCCount ,prCount,prCCount, retinoCount, retinoCCount)
            
            % END OF EXPERIMENT
            if block==numBlocks
                % save .MAT file
                run sizing; % get pixel dimensions
                save (OutputFile, 'Results');
                
                run joker
                
                Screen('TextFont', window, 'Helvetica');
                Screen('TextSize', window, 30);

                endOfPrac = 'Thank you for your participation!\nThis concludes the session!\n\nPlease go get your experimenter. (Q to quit!)';

                DrawFormattedText(window,endOfPrac,'center' ,'center', 0) ;
                Screen('flip', window);
                
                % Q to quit
                endExp = 1; 
                while endExp
                    [keyIsDown_endExp, pressedSecs_endExp, keyCode_endExp] = KbCheck(keyboardNum);
                    if keyIsDown_endExp
                        endExpKey = KbName(find(keyCode_endExp));
                        TF_endExp = strcmp(endExpKey, 'q');
                        if TF_endExp == 1
                            WaitSecs(.2);
                            break;
                        end
                    end
                end
                ShowCursor();
                if ETconnected == 1
                    Eyelink('Shutdown');
                end
                ListenChar(0);  
                Priority(0);
                trial = maxTrials + 1; 
                sca; 
                return
                % END OF BLOCK
            else             
                % SELF-PACED BREAK BETWEEN BLOCKS
                save (OutputFile, 'Results');
                
                run joker;
                
                Screen('TextFont', window, 'Helvetica');
                Screen('TextSize', window, 25);

                breakText = '\nYou may now take a quick a break\nto relax your eyes.\n\nBe sure to move your head back\nto the chin rest before you resume.\n\n\nPress the [SPACE] key when\nyou are ready to continue';
                numBlocksDoneText = sprintf('You have completed %d out of %d blocks', block, numBlocks);
                DrawFormattedText(window,breakText,'center' ,'center', 0);
                DrawFormattedText(window,numBlocksDoneText,'center' ,rect(2)+150, 0);
                Screen('flip', window);
                quickBreak = 1;
                while quickBreak
                    [keyIsDown_quickBreak, pressedSecs_quickBreak, keyCode_quickBreak] = KbCheck(keyboardNum);
                    if keyIsDown_quickBreak
                        breakKey = KbName(find(keyCode_quickBreak));
                        TF_breakKey = strcmp(breakKey, 'space');
                        quitKey = strcmp(breakKey, 'q');  
                        if TF_breakKey == 1
                            clear quickBreak;
                            Screen('flip', window);
                            break;
                        end   
                        if quitKey == 1
                            clear quickBreak;
                            Screen('flip', window);
                            break;
                        end   
                    end 
                end    
                 
                if quitKey == 1
                    ShowCursor();
                    if ETconnected == 1
                        Eyelink('Shutdown');
                    end
                    ListenChar(0);
                    Priority(0);
                    sprintf('probeScore = %.3f\t memoryScore = %.3f\n memoryOffset = %.3f\n', probeScore, score, memoryTestOffset)
                    trial = maxTrials + 1;
                    block = numBlocks + 1; 
                    sca; 
                    return    
                end
                clear memCueLoc absFixEnd sac_duration Delay cutoff_thresh; 
                
                block = block + 1;
                trial = trial+1;
                grandTrial = grandTrial + 1;
                % create new ET file for next block
                matETfile_name = ([expt_ID '_s' num2str(subj_num) '_' subj_init '_' num2str(block) '_ET.mat']);
                %Reset eyetracking variables
                mx = []; my = []; ma = [];
                matETttrial = []; matETtblock = []; ma{trial} = [];
                mx{trial} = [];  my{trial} = []; matETttrial{trial} = []; matETtblock{trial} = [];
            end
            WaitSecs(.5); % IBI
            % END OF TRIAL
        else
            % save .MAT file
            save (OutputFile, 'Results');
            clear probe_start_loc probe_end_loc memCueLoc probeJudgement RT_probe probeAcc absFixEnd sac_duration Delay cutoff_thresh;
            trial = trial + 1;
            grandTrial = grandTrial + 1;
            %Reset eyetracking variables
            et_good_check = 0; et_total_check = 0; et_null_check = 0; fixlosscount = 0;
            ma{trial} = []; mx{trial} = []; my{trial} = [];
            matETttrial{trial} = []; matETtblock{trial} = [];
            WaitSecs(.5); % ITI
        end
    end % end trial loop
end % end block loop
