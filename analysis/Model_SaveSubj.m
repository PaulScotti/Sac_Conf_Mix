clear;
clc;

% add folders to path
cwd = '/Users/scotti.5/Dropbox/Shared Lab Folder/Experiments/Sac_ConfMix/analysis';
resultsDir = strrep(cwd,'/Sac_ConfMix/analysis','/Sac_ConfMix/data/mat');
cd .. 
memToolboxDir = strrep(resultsDir,'data/mat','MemToolbox');
addpath(genpath((memToolboxDir)));
analysisDir = cwd;
addpath(genpath((analysisDir)));

% select what model you want to use
model2 = SwapModel_SacMix;

% Collapse if visualizing data, don't if doing stats testing
subj_collapsed = 1;

subject_pool = [1];

for pop = subject_pool

subjects = pop;

% subjects =  [1:20,22:23,25:27];

%% Organize and Load Data
if subj_collapsed
    ResultsFull =[];
    for p = 1:length(subjects)
        subjNum = num2str(subjects(p))
        d = dir(fullfile(resultsDir, ['Results_s' subjNum '_*' '.mat']));
        load(fullfile(resultsDir, d.name));
        ResultsFull = [ResultsFull; Results];
    end
    subject{1} = ResultsFull;
    numSubj = 1;
elseif ~subj_collapsed
    for p = 1:length(subjects)
        subjNum = num2str(subjects(p))
        d = dir(fullfile(resultsDir, ['Results_s' subjNum '_*' '.mat']));
        load(fullfile(resultsDir, d.name));
        subject{p} = Results;
    end
    numSubj = length(subjects);
end

%% Process the Data
for p = 1:numSubj
    nearer=0;farther=0;
    
    Results = subject{p};

    run results_setup;

    da_1 = []; da_2 = []; da_3 = []; da_4 = [];
    Rdist=[];Cdist=[];

    for i = 1:length(trialNum)
        if saccade(i) == 0 % no saccade, 50 ms
            da_1 = [da_1; col_diff(i)];
        elseif saccade(i) == 1 % no saccade, 500 ms
            da_2 = [da_2; col_diff(i)];
        elseif saccade(i) == 2 % saccade, 50 ms
            da_3 = [da_3; col_diff(i)];
        elseif saccade(i) == 3 % saccade, 5000 ms
            da_4 = [da_4; col_diff(i)];
        end
        
        if saccade(i) == 2
            switch retino(i)
                case 1
                    switch position(i) 
                        case 1
                            Rdist = [Rdist; nan];
                            Cdist = [Cdist; nan];
                        otherwise
                            Rdist = [Rdist; wrap360(testColor(i),UL(i))];
                            Cdist = [Cdist; -Rdist(end)];
                    end
                case 2
                    switch position(i) 
                        case 2
                            Rdist = [Rdist; nan];
                            Cdist = [Cdist; nan];
                        otherwise
                            Rdist = [Rdist; wrap360(testColor(i),UR(i))];
                            Cdist = [Cdist; -Rdist(end)];
                    end
                case 3
                    switch position(i) 
                        case 3
                            Rdist = [Rdist; nan];
                            Cdist = [Cdist; nan];
                        otherwise
                            Rdist = [Rdist; wrap360(testColor(i),LL(i))];
                            Cdist = [Cdist; -Rdist(end)];
                    end
                case 4
                    switch position(i) 
                        case 4
                            Rdist = [Rdist; nan];
                            Cdist = [Cdist; nan];
                        otherwise 
                            Rdist = [Rdist; wrap360(testColor(i),LR(i))];
                            Cdist = [Cdist; -Rdist(end)];
                    end
            end
        end
    end
    
    distractors(1,:) = Rdist;
    distractors(2,:) = Cdist;
    
    % make retinotopic distractor positive and control negative
    for i = 1:length(distractors)
        if Rdist(i) < 0
            Rdist(i) = - Rdist(i);
            Cdist(i) = - Cdist(i);
            da_3(i) = - da_3(i);
        end
    end

    da_a = [da_3];
    datasets_a.errors = da_a;
    datasets_a.subjectID = p;
    datasets_a.distractors = distractors;
    data_a{p} = datasets_a;
    
    disp(['avg err: ', num2str(nanmean(abs(col_diff)))]);
end

% fit = MemFit(data_a{p},model2);
% 
% global falseConverge
% while falseConverge %if subject didn't converge, try again
%     fit = MemFit(data_a{p},model2);
% end

% savefig(['subject', num2str(pop)]);
% save(['subject',num2str(pop),'fit.mat'],'fit');
% close all

end
