%% Timing relative 
drawFixTimeRel = drawFixTime - trialStartTime;
startedFixTimerRel = startedFixTimer - drawFixTime;
drawMemCueTimeRel = drawMemCueTime - startedFixTimer;
remMemCueTimeRel = remMemCueTime - drawMemCueTime;
drawSacTimeRel = drawSacTime - remMemCueTime;
drawProbeTimeRel = drawProbeTime - drawSacTime;
remProbeTimeRel = remProbeTime - drawProbeTime;
drawMemTestRel = drawMemTest - remProbeTime;
drawMasksRel = drawMasks - drawMemTest;
remMasksRel = remMasks - drawMasks;
madeClick3Rel = madeClick3 - madeClick2;
madeClick2Rel = madeClick2 - madeClick1;
madeClick1Rel = madeClick1 - startReport;

%% DATE
Date = datestr(date);
dt = datestr(now, 'mmmm dd, yyyy HH:MM:SS.FFF');

%% ASSIGN ET PARAMETERS IF NO ET
if ~ETconnected
    sac_duration = NaN;
    prefix_duration = NaN; 
    prefix_execution = NaN;
    sac_execution = NaN;
    et_good_check = NaN;
    et_null_check = NaN;
    et_total_check = NaN;
end

Results(grandTrial,:) = {...
    dt,...1
    subj_init,... 2
    subj_num,...  3
    session,...4
    block,... %5
    trial,...
    grandTrial,... 7  
    saccade,...
    firstFix',... 9
    newFix',...   10 
    position,...
    memCueLoc,... 
    ffPos,... 13
    nfPos,... 
    cueDist2ff,...15
    cueDist2nf,... 
    PPD,...17
    DPP,... 
    testColor,...19
    reportedcolor,...
    confValues,...21
    confValues2,...
    startingcolor,...23
    randrotate,...
    flip,...25
    asymmetric,...
    trialStartTime,...  27
    drawFixTimeRel,...
    startedFixTimerRel,...29
    drawMemCueTimeRel,... 
    remMemCueTimeRel,...31
    drawSacTimeRel,...
    drawProbeTimeRel,...33
    remProbeTimeRel,...
    drawMemTestRel,...  35
    drawMasksRel,...36
    remMasksRel,...37
    startReport,...38
    madeClick1Rel,...
    madeClick2Rel,...40
    madeClick3Rel,...
    prefix_execution,...  42
    prefix_duration,... 
    sac_execution,...44
    sac_duration,...
    et_good_check,...46
    et_null_check,...
    et_total_check,...48
    practice};

%% RECORD ET DATA TO .MAT FILE
if ETconnected
    cd data/ET
    save(matETfile_name,'mx','my','ma','matETttrial','matETtblock'); 
    cd ..; cd ..
end

 
