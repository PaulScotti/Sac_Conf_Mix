%% % BASIC SETUP STUFF
maxPracTrials = 10; % max practice trials
correctFix = 0;
% Number of succesful saccades needed in order to move on
correctFixMinP1 = 6; 

%% PART 1 INSTRUCTIONS (HORIZONATAL & VERTICAL EYE MOVEMENTS)
% Subject needs to correctly make 10 saccades and remain fixted for 500ms at
% both the initial fixation location and the new fixation location

Directory.Instruct1 = [Directory.mainDir, filesep, 'Instruct1'];

% Loop through instructions
practiceInstructionFiles = dir([Directory.Instruct1 filesep 'I*']); % place instruction PNGs into a structure

for page = 1:length(practiceInstructionFiles)
    Instruct{page} = imread([Directory.Instruct1 filesep practiceInstructionFiles(page).name]);
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
        Screen('DrawTexture', window, stimuli{1}.instructprac,[], instructRect);
        Screen('Flip', window);
        pageCounter = 1;
        WaitSecs(.5);
%     elseif pageCounter > length(practiceInstructionFiles)  PAUL comment: this code will never execute cus of while loop??
%         Screen('DrawTexture', window, stimuli{length(practiceInstructionFiles)}.instructprac, [], instructRect);
%         Screen('Flip', window);
%         pageCounter = length(practiceInstructionFiles);
    elseif pageCounter < 1 % Keep page at 1 if left arrow on first page
        Screen('DrawTexture', window, stimuli{1}.instructprac, [], instructRect);
        Screen('Flip', window);
        pageCounter = 1;
    else
        Screen('DrawTexture', window, stimuli{pageCounter}.instructprac, [], instructRect);
        Screen('Flip', window);
        WaitSecs(.5);
    end
    
    if pageCounter == length(practiceInstructionFiles) % if on last page
        % SPACE to start, nothing happens with right arrows
        keyNav = [KbName('LeftArrow'), KbName('space'), KbName('escape')];
        while ~any(ismember(keyNav, find(keyCode)));
            [secs, keyCode, deltaSecs] = KbWait([],3);
        end
        
        response = find(keyCode);
        response = response(1); %Take the first keyboard input if multiple
        responseKey = KbName(response);

        if strcmp (responseKey, 'LeftArrow')
            pageCounter = pageCounter-1;
        elseif strcmp (responseKey, 'space') 
            pageCounter = pageCounter+1;
            %             break
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
                elseif strcmp (responseKey, 'ESCAPE') %Go to last page
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

%%  PART 1 TASK (HORIZONATAL & VERTICAL EYE MOVEMENTS)
while t <= maxPracTrials;
    for t = 1:40
        [timer stimonset fliptime missed beampos]=Screen('Flip', window);
        trialStartTime = timer;
        
        firstFix = fixations(:, randi(4)); %first fixation is one of 4 random locations
        %     Setting saccade target locations based on first fixation location
        if firstFix == A';
            newFixation = [B;C]';%Setting up saccade location based on first fixation-->no oblique saccades
        elseif firstFix == B';
            newFixation = [A;D]';%Setting up saccade location based on first fixation-->no oblique saccades
        elseif firstFix == C';
            newFixation = [A;D]';%Setting up saccade location based on first fixation-->no oblique saccades
        elseif firstFix == D';
            newFixation = [B;C]';%Setting up saccade location based on first fixation-->no oblique saccades
        end;
        %     Pick new fixation location-- Pick all rows (X,Y) but one random column for one fixation
        newFix = newFixation(:, randi(2));
        
        % DRAW AND WAIT FOR INITIAL FIXATION
        Screen('DrawDots', window,firstFix,[10],white, [0,0], 1);
        [timer stimonset fliptime missed beampos] = Screen('Flip', window);
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
        [timer stimonset fliptime missed beampos] = Screen('Flip', window);
        absfixtime(1) = timer;
        firstFixTime = timer;
        staretime = timer + .5;
        curfx = firstFix(1);
        curfy = firstFix(2);
        allowanswer = 0;
        run keepFix; % must keep fixation for 500ms
        if runfailed
%             correctFix = correctFix+0; Paul comment: this is worthless
%             line right?
            continue
        end
        
        % DRAW SACCADE CUE AND WAIT UNTIL FIXATION ACQUIRED
        Screen('DrawDots', window,newFix,[10],white, [0,0], 1);
        [timer stimonset fliptime missed beampos] = Screen('Flip', window);
        newFixCueTime = timer;
        abssaccuetime(1) = timer;
        curfx = newFix(1);
        curfy = newFix(2); 
        FixID = 2;
        run checkFix; %600ms to gain fixation at new location
        if runfailed
            continue
        end
        
        % KEEP FIXATED FOR ANOTHER 500 MS
        Screen('DrawDots', window,newFix,[10],white, [0,0], 1);
        [timer stimonset fliptime missed beampos] = Screen('Flip', window);
        newFixTime = timer;
        abssactime(1) = timer;
        staretime = timer + .5;
        curfx = newFix(1); 
        curfy = newFix(2);
        allowanswer = 0;
        run keepFix; % must keep fixation for 500ms
        if runfailed
%             correctFix = correctFix + 0; Paul comment: This is worthless
%             line, right?
            continue
        elseif ~runfailed
            correctFix = correctFix + 1;
        end
        
        % 1200ms OF BLANK SCREEN BEFORE NEXT TRIAL %Paul comment: why such
        % long ITI?
        blankScreenTime = Screen('Flip', window);
        WaitSecs(1.2);
        
        if correctFix >= correctFixMinP1 || t == maxPracTrials;
            correctFix = 0;
            clear t;
            break;
        else
            t = t + 1;
        end;
    end
    break
end 

