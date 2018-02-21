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
    run EyelinkExample; %Better than standard setup, recommended by EWD, PS modified
else
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

    % To prevent typing into the matlab code editor
    commandwindow; 
    
    % Turn off the output to the command window
    ListenChar(2);
end

%% RUN TASK 
% Set up stim locations
run setVariables;

% Practice loops
if practice == 1
    run practice_part1 % practice no saccade memory cue only, 4 of last 5 trials corr to continue
    if ETconnected 
        run eyelink_setup;  
    end
    run end_of_practice;
end

practice=0;
run Trial_Loop;


