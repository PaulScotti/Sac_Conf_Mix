%Keeps track of the participant's eye location for a designated
%time (staretime), without checking fixation. 

fixdone_variable = 0;
runfailed = 0;
et_total_check = 0;
et_null_check = 0; 

% Simply recording (no fixation required) 
% Loop until a pre-determined duration, when current time is equal to or 
% greater than the set staretime delay
while fixdone == 0 && cutoff_thresh < .6 %saccade needs to complete < 600 ms
    if ETconnected
        error = Eyelink('CheckRecording');        
        if Eyelink( 'NewFloatSampleAvailable') > 0
            % get the sample in the form of an event structure
            evt = Eyelink( 'NewestFloatSample');

            if increment_fix_vars
                et_total_check = et_total_check + 1;
            end

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

                    mx{trial} = [mx{trial} x];
                    my{trial} = [my{trial} y];
                    ma{trial} = [ma{trial} a];
                    matETttrial{trial} = [matETttrial{trial} et_trial];
                    matETtblock{trial} = [matETtblock{trial} et_block];
                    dist_from_fix = round(((x - curfx) ^ 2 + (y - curfy) ^ 2 ) ^ (1 / 2));
                    if look_for_fix
                        if dist_from_fix < fixradthresh
                            absFixEnd = GetSecs();
                            if FixID == 1 %just fixation
                                prefix_duration = absFixEnd - drawFixTime;
                            elseif FixID == 2 %saccade
                                sac_execution = absFixEnd;
                                sac_duration = sac_execution - drawSacTime;
                                FixID = 0; % so that the loop only captures the first time that the eye hits the fixation target
                            end
                            fixdone_variable = 1;
                        else
                            fixdone = 0;
                            %Update cutoff_thresh to ensure it takes less than 600 ms for them to saccade to new fixation
                            cutoff_thresh = (GetSecs) - drawSacTime; %600 ms max to get to new fixation
                        end
                    end

                    % Check to see if eye is on probe during probe display
                    if practice ~= 1 
                        discard = 0;
                        if probeEyeCheck == 1  % eye on probe check
                            if x >= probeBoxTLX && x <= probeBoxBRX && y >= probeBoxTLY && y <= probeBoxBRY
                                eyes_on_probe = 1;
                                discard = 1;
                                probeEyeCheck = 0;
                                runfailed = 1;
                            else 
                                eyes_on_probe = 0;
                            end
                        end
                        % label trials as discard or not (mostly helpful for trials where the probe appears after the saccade cue)
                        discard_trials(trial) = [discard]; 
                    else
                        if increment_fix_vars
                            et_null_check = et_null_check + 1;
                        end
                    end
                end
            end
            if fixdone_variable == 1
                fixdone = 1;
            end
        end
    else
        cutoff_thresh = (GetSecs) - drawSacTime;
    end
end


if ~fixdone
    sac_duration = 9999;
end

if ~fixdone && cutoff_thresh >= .6 && ETconnected
    runfailed = 1;
    sac_duration = 9999;
end

%%
if runfailed == 1
    clear sac_duration; 
    clear cutoff_thresh; 
    clear Delay;  
    ma{trial} = [];
    mx{trial} = [];
    my{trial} = [];
    matETttrial{trial} = [];
    matETtblock{trial} = [];
    %Screen('FillRect', w, [128 64 64], rect);
    Screen('DrawLine', window, [200 0 0], (screenCenterX - 250), (screenCenterY - 250), (screenCenterX+250), (screenCenterY+250), 4);
    Screen('DrawLine', window, [200 0 0], (screenCenterX + 250), (screenCenterY - 250), (screenCenterX-250), (screenCenterY+250), 4);
    Screen('Flip',window); 
    WaitSecs(.25);
    Screen('Flip',window);
    WaitSecs(.75); %Short ITI between failed trial and new trial
end