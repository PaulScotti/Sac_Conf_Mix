%% USED FOR WHENEVER FIXATION IS TO BE MAINTAINED (GAZE-CONTINGENT)
fixlosscount = 0;
et_total_check = 0;
et_good_check = 0;
et_null_check = 0;

increment_fix_vars = 1;

runfailed = 0;
%%

% Keeps track of the participant's eye location for a designated
% time (staretime), and measures if the subject is within
% acceptable range of the fixation point (curfx, curfy).

while GetSecs < staretime
    
    if ETconnected
        error = Eyelink('CheckRecording');
        if(error ~= 0)
        end
        
        if Eyelink('NewFloatSampleAvailable') > 0
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
                    
                    if increment_fix_vars
                        dist_from_fix = round(((x - curfx) ^ 2 + (y - curfy) ^ 2 ) ^ (1 / 2));
                        if dist_from_fix < fixradthresh
                            et_good_check = et_good_check + 1;
                        else
                            fixlosscount = fixlosscount + 1;
                        end
                    end
                else
                    if increment_fix_vars
                        et_null_check = et_null_check + 1;
                        dist_from_fix = 0;
                    end
                end
            end
        end
    end
end

if fixlosscount > fixlosscount_thresh % 30
    runfailed = 1;
else
    runfailed = 0;
end 

%%
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
    WaitSecs(.75); %Short ITI between failed trial and new trial
end