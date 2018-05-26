%% BASIC SETUP 

% Define black and white (white will be 1 and black 0). This is because in general luminace values are defined between 0 and 1 with 255 steps in between. All values in Psychtoolbox are defined between 0 and 1
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);

% Do a simple calculation to calculate the luminance value for grey
grey = white / 2;
 
%Open up Psychtoolbox and fit to screen size
Screen('Preference', 'SkipSyncTests', 1); %disable warning pop-ups
if ~ETconnected
    try
    Screen('Preference', 'SkipSyncTests', 0); %EWD 4/27/18
    [window,rect] = Screen('OpenWindow',screenNumber, grey);
    catch
    Screen('Preference', 'SkipSyncTests', 1);
    [window,rect] = Screen('OpenWindow',screenNumber, grey);
    end
elseif ETconnected
    try
    Screen('Preference', 'SkipSyncTests', 0);
    [window,rect] = Screen('OpenWindow',screenNumber, grey);
    catch
    Screen('Preference', 'SkipSyncTests', 1);
    [window,rect] = Screen('OpenWindow',screenNumber, grey);
    end
end


% Alpha blending, helps with smoothing
Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

% Get rate at which monitor refreshes.....usually 60 frames per second (.0167 seconds per frame)
monitorFlipInterval = Screen('GetFlipInterval', window);

% Retreive the maximum priority number and set priority
topPriorityLevel = MaxPriority(window);
Priority(topPriorityLevel);
 
% Create folder and file where data  will be stored
% Results raw data
DataFolderMat = [cur_dir '/data/mat']; % Location to save data
OutputFile = [DataFolderMat '/Results_s' subjNum '_' subj_init '.mat'];
%For practice data
DataFolderPrac = [cur_dir '/data/prac']; % Location to save data
OutputFilePrac = [DataFolderPrac '/ResultsT_s' subjNum '_' subj_init '.mat'];
% ET Results 
DataFolderET = [cur_dir '/data/ET']; % Location to save data
OutputFileET = [DataFolderET '/ResultsET_s' subjNum '_' subj_init '.mat'];

% Find screen centers and other relevant location information 
screenWidth = rect(3);
screenHeight = rect(4);
screenCenterX = screenWidth / 2;
screenCenterY = screenHeight / 2;
screenRatio = screenWidth / screenHeight; 

% Rect smaller than window where stim can be shown %Paul comment: why change the window like this?
stimRect = [(screenWidth - screenHeight) / 2, rect(2), screenWidth - ((screenWidth - screenHeight) / 2), rect(4)]; % square within the monitor rectangle 
stimRectHeight = screenHeight; 
stimRectWidth = stimRectHeight;
% Dimensions of extra screen space along X-axis (screen width minus stim rect width) on one single side 
extraScreenX = (screenWidth - stimRectWidth) / 2;

%% Verify equiluminance and color correction      
CIEL = 70;
CIEa = 20;
CIEb = 38;

% Convert CIE to RGB
switch testingRoom
    case 1
        whitexyY = [.282 .306 96.75]'; %for testing room A (jglab)
    case 2
        whitexyY=[.348 .422 89.5]'; %for testing room B (jglab)
end

whiteXYZ = xyYToXYZ(whitexyY);
Color.XYZ = LabToXYZ([CIEL;CIEa;CIEb],whiteXYZ);
Color.rgb=XYZToSRGBPrimary(Color.XYZ);
Color.rgb2=SRGBGammaCorrect(Color.rgb)';

%% VISUAL ANGLE 
 
monitor = Screen(window,'Resolution');

%Numbers listed here are the default for the scan room & our testing chamber
xsize = monitor.width; %1280;
ysize = monitor.height; %1024;

centi_from_monitor = 61; 
monitor_measurement = 40;
pixel_measurement = xsize;

monitor_VA_deg = atan((monitor_measurement / 2) / centi_from_monitor) * (2) * (180 / pi);

%Pixels per degree
PPD = pixel_measurement / monitor_VA_deg;

%degrees per pixel  
DPP = 1 / PPD; 

%% FIRST FIXATION LOCATIONS 

% FOUR POSSIBLE FIXATION LOCATIONS, approximate depiction below 
%  - - - - - - - - - - -
% |   1      2       3  |
% |      *A      *B     |
% |                     | 
% |   4      5       6  |
% |                     |
% |      *C      *D     |
% |   7      8       9  |
%  - - - - - - - - - - -
A = [(extraScreenX + (stimRectWidth / 3)), (stimRectWidth / 3)]; % Top Left
B = [(extraScreenX + (2 * (stimRectWidth / 3))), (stimRectWidth / 3)]; % Top Right
C = [(extraScreenX + (stimRectWidth / 3)), (2 * (stimRectWidth / 3))]; % Bottom Left
D = [(extraScreenX + (2 * (stimRectWidth / 3))), (2 * (stimRectWidth / 3))]; % Bottom Right

% Fixation locations vector 
fixations = [A ;B; C; D]'; 
 
fixationSizeDeg = .2; % .12 in 2008 paper 
fixationSize = fixationSizeDeg / DPP; % pixels 

%% ZONE LOCATIONS 
% SET UP CENTERS FOR EACH CUE ZONE 
zOne.center = [(extraScreenX + (stimRectWidth / 6)), (stimRectWidth / 6)];
zTwo.center = [(extraScreenX + (3 * (stimRectWidth / 6))), (stimRectWidth / 6)];
zThree.center = [(extraScreenX + (5 * (stimRectWidth / 6))), (stimRectWidth / 6)];
zFour.center = [(extraScreenX + (stimRectWidth / 6)), (3 * (stimRectWidth / 6))];
zFive.center = [(extraScreenX + (3 * (stimRectWidth / 6))), (3 * (stimRectWidth / 6))];
zSix.center = [(extraScreenX + (5 * (stimRectWidth / 6))), (3 * (stimRectWidth / 6))];
zSeven.center = [(extraScreenX + (stimRectWidth / 6)), (5 * (stimRectWidth / 6))];
zEight.center = [(extraScreenX + (3 * (stimRectWidth / 6))), (5 * (stimRectWidth / 6))];
zNine.center = [(extraScreenX + (5 * (stimRectWidth / 6))), (5 * (stimRectWidth / 6))];

%% MEMORY CUE LOCATIONS 
% IF INTIAL DISTANCE SEPERATING CUE LOCATIONS IS 1.5º, CUES WILL BE +/- .75º FROM ZONE CENTER 
% DPP for testing computers: 0.0284

memCueDeg = 2; %height/width of memory cue 
memOffsetDeg = 7.4; %eccentricity
memCueDim = (memCueDeg / DPP) / 2; % divided by 2 because helps with referencing from cue center  
intialGap = (memOffsetDeg/DPP) - (2 * memCueDim);  

%% INITIATE TRIAL 

% Trial number starts at 1
trial = 1; 

% Maximum number of trials
maxTrials = trialsPerBlock; %set at input prompt window 
 
% Grand trial (for data collection purposes only)
grandTrial = 1;

% Number of correct memory tests beginning of experiment
correctCount = 0;

% Probe score to begin with 
correctProbeCount = 0;  
allProbeCount = 0;

%% ET PARAMETERS 
% (Borrowed from LandMemSpa set_variables.m) 

fixlossradVA = 2;
fixlossrad = round(fixlossradVA * PPD);
fixradthresh = fixlossrad;
fixlosscount_thresh = 40; % threshold for each Flip

% mx = 0;
% my = 0;
% ma = 0; 

%Reset eyetracking variables
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

% Mask randomizer
vectorfullcolormatrix = reshape(fullcolormatrix,[],1);
for rgb = 1:3
    for row = 1:round(memCueDim*2)
        for col = 1:round(memCueDim*2)
            mask(row,col,rgb) = vectorfullcolormatrix(randi(length(vectorfullcolormatrix)));
        end
    end
end

%% Condition Randomizer
xTally = 0; %keep track of Xs in a row

% Determine trial types
saccadeBank = BalanceFactors(totaltrials/4, 1, [0 1 2 3]); % 0: no sac (50ms), 1: no sac (500 ms), 2: 50 ms, 3: 500 ms


