% Basic Eyelink Eyetracker setup. Assumes that the eyetracker is
% connected, and instantiates the eyelink object as 'el'.
dummymode = 0;

tmp = EyelinkInit(0); %first input variable is "dummy" --> Omit, or set to 0 to attempt real initialization, set to 1 to enforce to use initializedummy for dummy mode.
el = EyelinkInitDefaults(window); %Initialize eyelink defaults and control code structure
%ListenChar(2); %disables output to Matlab window; reenable later!

bg_color = [255 255 255];
% el.backgroundcolour = bg_color;
el.backgroundcolour = grey;
el.foregroundcolour = 255;  %what's the differenece btwn foregroundcolour and calibtargetcolour?
el.calibrationtargetcolour= 0;
el.msgfontcolour  = 0;
el.targetbeep = 0;

EyelinkUpdateDefaults(el);

Eyelink('Command','screen_pixel_coords = %ld %ld %ld %ld', 0,0,rect(3)-1, rect(4)-1); % 0, 0, SCREEN_X-1, SCREEN_Y-1
Eyelink('message', 'DISPLAY_COORDS %ld %ld %ld %ld', 0,0,rect(3)-1, rect(4)-1);

Eyelink('Command', 'link_sample_data = LEFT,RIGHT,GAZE,AREA'); % make

edfFile='demo.edf';
Eyelink('Openfile', edfFile);

% Calibrate the eye tracker
EyelinkDoTrackerSetup(el);

% do a final check of calibration using driftcorrection
% EyelinkDoDriftCorrection(el);

WaitSecs(0.1);
begin_record_time = GetSecs();
Eyelink('StartRecording'); %Start recording with data types requested 

eye_used = Eyelink('EyeAvailable'); % get eye that's tracked ()=left, 1=right, 2= binocular, -1=none availble)
if eye_used == el.BINOCULAR; % if both eyes are tracked
    eye_used = el.LEFT_EYE; % use left eye
end

[a,b]=RectCenter(rect);
WaitSetMouse(a,b,0); % set cursor and wait for it to take effect

% HideCursor;
buttons=0;

% priorityLevel=MaxPriority(w);
% Priority(priorityLevel);

% Wait until all keys on keyboard are released:
while KbCheck; WaitSecs(0.1); end;

mxold=0;
myold=0;

oldvbl=Screen('Flip', window);
tavg = 0;
ncount = 0;