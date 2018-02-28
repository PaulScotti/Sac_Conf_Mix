% NOTE: the n-counter thing I use here is just a quick workaround
% to allow me to alter the order and add/remove variables from the
% input prompts quickly, code wise. (NF)

% Modified from xyz_fMRI2 01/22/2015

expt_ID = 'ProbabilityTrace';

% Basic Setup
n = 1;
prompt{n} = 'Experiment ID';
defaults{n} = expt_ID; n = n + 1;
prompt{n} = 'Subject Initials';
defaults{n} = 'test'; n = n + 1;
prompt{n} = 'Subject Number';
defaults{n} = '999'; n = n + 1;
prompt{n} = 'Start Block';
defaults{n} = '1' ;   n    =   n   +  1;
prompt{n} = 'Number of Blocks';
defaults{n} = '12' ;   n    =   n   +  1;
prompt{n} = 'Trials per Block'; %60 trials are spatio
defaults{n} = '32'; n = n + 1;
prompt{n} = 'PracTrials';  
defaults{n} = '16'; n = n + 1;
prompt{n} = 'Eyetracker Connected? (0/1)';
defaults{n} = '0'; n = n + 1; 
prompt{n} = 'Testing Room';
defaults{n} = 'B'; n = n + 1;
prompt{n} = 'Practice (0/1)'; 
defaults{n} = '0'; n = n + 1;

answer = inputdlg(prompt,'Input Variables',1,defaults);

n = 1;
expt_ID = answer{n}; n = n + 1;
subj_init = answer{n}; n = n + 1; 
subj_num = str2num(answer{n}); n = n + 1;
block = str2num(answer{n}); n = n + 1;
numBlocks = str2num(answer{n}); n = n + 1;
trialsPerBlock = str2num(answer{n}); n = n + 1; 
pracTrialNum = str2num(answer{n}); n = n + 1; 
ETconnected = str2num(answer{n}); n = n + 1;
testingRoom = answer{n}; n = n + 1;
practice = str2num(answer{n}); n = n + 1;

subjNum = num2str(subj_num);  
testroom = num2str(testingRoom); 
totaltrials = trialsPerBlock * numBlocks;

if testingRoom == 'A' || testingRoom == 'a' 
    testingRoom = 1;
else 
    testingRoom = 2;
end


