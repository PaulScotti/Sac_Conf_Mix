%% SET UP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Clear the workspace and the command window
clear;
clc;
ClockRandSeed;

% All of the scripts utilized herein are added to MATLAB path
cur_dir = pwd;
addpath(genpath([pwd '/CodeLibrary_ET']));

% Color wheel load
load('colorwheel360.mat', 'fullcolormatrix');

% Startup window
run inputPrompt;

% Setup eye tracker if ET on/connected
HideCursor;
if ETconnected
    run EyelinkExample;
end

% Sync tests
Screen('Preference', 'SkipSyncTests', 0); %1 means skip, 0 means do not skip

% Number for each of the screens attached to our computer
screens = Screen('Screens'); % [0, 1] 0 is the main display with the menu bar and 1 is the first external display
KbName('UnifyKeyNames');

% Select which screen/monitor to draw on
screenNumber = max(screens); % use large display on dual monitor screens (external monitor)

% Keyboard check
keyBoards = GetKeyboardIndices;
keyboardNum = max(keyBoards);

% Mouse Check
mice = GetMouseIndices;
mouseNum = max(mice);

%% RUN TASK 

% To prevent typing into the matlab code editor
commandwindow; 
% hide cursor
HideCursor;

% Set up stim locations
run setVariables;

% Go back to regular ET setup
if ETconnected 
    run eyelink_setup.m
end

% Turn off the output to the command window
ListenChar(2);

% Practice loops
if practice == 1
    global Directory
    Directory.mainDir = pwd;
    if session == 1
        run practice_part2 % practice no saccade memory cue only, 4 of last 5 trials corr to continue
        if ETconnected 
            run eyelink_setup;  
        end
        
        run practice_1 % no saccade QUEST practice
        if ETconnected 
            run eyelink_setup;  
        end
        clear Results;
        
        %tell participant to do the practice and follow the instructions
        %and to come back out if need calibration or have questions
        run practice_3; %50 trials 50% spatio no saccade
        clear Results;
        
        run practice_2; % saccade practice
        clear Results;
    end
    if session > 1
        run practice_25; % saccade practice, half trials
        clear Results;
    end

    run end_of_practice;
    correctProbeCount = 0; correctCount = 0;  %a precaution to make sure practice trials aren't included in real data
    pracDone = 1; 
elseif practice == 0  
    pracDone = 0;
end

practice=0;
run Trial_Loop;


