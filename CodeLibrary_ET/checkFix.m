%% USED FOR INITIAL FIXATION
runfailed = 0;
fixdone = 0;
presac_start_time = GetSecs();

%%
% Keeps track of the participant's eye location for a designated
% time (600ms), and measures if the subject is within
% acceptable range of the fixation point (curfx, curfy).

%USE BLOCKSTARTTIME HERE, AS THE TRIALSTART TIME IS BASED OFF OF IT

if ETconnected
    
    % quit if 600 ms have gone by or they have fixated
    while ((GetSecs() - presac_start_time) < .6) && ~fixdone
        
        if ETconnected
            error = Eyelink('CheckRecording'); 
            %check for presence of a new sample update
            if Eyelink( 'NewFloatSampleAvailable') > 0
                % get the sample in the form of an event structure
                evt = Eyelink('NewestFloatSample');
                
                if eye_used ~= -1 % do we know which eye to use yet?
                    % if we do, get current gaze position from sample
                    x = evt.gx(eye_used + 1); % +1 as we're accessing MATLAB array
                    y = evt.gy(eye_used + 1);
                    a = evt.pa(eye_used + 1);
                    eyetime = GetSecs();
                    % do we have valid data and is the pupil visible?
                    
                    if x ~= el.MISSING_DATA && y ~= el.MISSING_DATA && evt.pa(eye_used + 1) > 0
                        %RECORD PRE-TRIAL ET DATA HERE
                        et_trial = eyetime - drawFixTime;
                        et_block = eyetime - blockStartTime;
                        et_trialsave(trial) = et_trial;
                        if trial > 1
                            mx{trial - 1} = [mx{trial - 1} x];
                            my{trial - 1} = [my{trial - 1} y];
                            ma{trial - 1} = [ma{trial - 1} a];
                            matETttrial{trial - 1} = [matETttrial{trial - 1} et_trialsave(trial - 1)];
                            matETtblock{trial - 1} = [matETtblock{trial - 1} et_block];
                            
                        else
                            mx{trial} = [mx{trial} x];
                            my{trial} = [my{trial} y]; 
                            ma{trial} = [ma{trial} a];
                            matETttrial{trial} = [matETttrial{trial} et_trial];
                            matETtblock{trial} = [matETtblock{trial} et_block];
                            
                        end
                        
                        dist_from_fix = round(((x - curfx) ^ 2 + (y - curfy) ^ 2 ) ^ (1 / 2));
                        
                        %if distance from fixation is within acceptable
                        %range dictated by fixradthresh
                        if dist_from_fix < fixradthresh
                            fixdone = 1; %fixation was completed
                            absFixEnd = GetSecs();
                            if FixID == 1 %initial fixation
                                prefix_execution = absFixEnd; 
                                prefix_duration = prefix_execution - drawFixTime; % time is takes to complete fixation
                            elseif FixID == 2 %saccade target fixation
                                sac_execution = absFixEnd;
                                sac_duration = sac_execution - abssaccuetime(1); % time it takes to execute the saccade
                            end
                            break
                        end
                    else
                    end
                end
            end
        else
            fixdone = 1;
        end
    end
end


if ~fixdone && ETconnected
    runfailed = 1;
end
%%
%if saccaded and fixating but it took longer than 600 ms for them to do it
if FixID ==2 && ETconnected
    try
        if sac_duration > .6
            runfailed = 1; %abort trial
        end
    catch
        runfailed = 1;
    end
end

if runfailed == 1
    clear absFixEnd;
    clear sac_duration; 
    ma{trial} = [];
    mx{trial} = [];
    my{trial} = [];
    matETttrial{trial} = [];
    matETtblock{trial} = []; 
    Screen('DrawLine', window, [200 0 0], (screenCenterX - 250), (screenCenterY - 250), (screenCenterX+250), (screenCenterY+250), 4);
    Screen('DrawLine', window, [200 0 0], (screenCenterX + 250), (screenCenterY - 250), (screenCenterX-250), (screenCenterY+250), 4);
    Screen('Flip',window);
    WaitSecs(.25);
    Screen('Flip',window);
    WaitSecs(.74); %Short ITI between failed trial and new trial %Paul comment: why such specific ITI?
end