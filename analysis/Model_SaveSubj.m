toterr=[]; totvar=[]; ALLRESULTS=[];
for model = 1:2 %1:4 %see Golomb et al 2014 (1-4 correspond to models A B and C)
    for conds = 1:4 %(early/late no sacc; early/late sacc)
        clearvars -except conds model toterr totvar ALLRESULTS
        clc;

        % add folders to path
        cwd = '/Users/scotti.5/Dropbox/Shared Lab Folder/Experiments/Sac_ConfMix/analysis';
        cd(cwd);
        resultsDir = strrep(cwd,'/Sac_ConfMix/analysis','/Sac_ConfMix/data/mat');
        saveDir = strrep(cwd,'/analysis','/figures and fits');
        cd .. 
        memToolboxDir = strrep(resultsDir,'data/mat','MemToolbox');
        addpath(genpath((memToolboxDir)));
        analysisDir = cwd;
        addpath(genpath((analysisDir)));

        % select what model you want to use
        if model == 1
            model2 = SwapModel_SacMixA;
        elseif model == 2
            model2 = SwapModel_SacMixB;
        elseif model == 3
            model2 = SwapModel_SacMixC;
        elseif model == 4
            model2 = SwapModel_SacMixD;
        end

        analyzeSac = conds-1; % select which condition to analyze (0 - 3)
        % 0 = early no sacc
        % 1 = late no sacc
        % 2 = early sacc
        % 3 = late sacc

        subject_pool = [29:36,38,39,41:43]; %[2,5,8,9:16,18:20,22:23]

        for confLevel = 1:2 %1:3 %1=high conf 2=low conf 3=all data
            clearvars -except analyzeSac subject_pool subj_collapsed model2 resultsDir analysisDir memToolboxDir saveDir conds confLevel model toterr totvar ALLRESULTS
            for pop = 98989 %subject_pool

%                 subjects = pop;
                
                subjects = [29:36,38,39,41:43];

                %% Organize and Load Data
                ResultsFull =[];
                for p = 1:length(subjects)
                    subjNum = num2str(subjects(p))
                    d = dir(fullfile(resultsDir, ['Results_s' subjNum '_*' '.mat']));
                    load(fullfile(resultsDir, d.name));
                    ResultsFull = [ResultsFull; Results];
                end
                subject{1} = ResultsFull;

                %% Process the Data
                nearer=0;farther=0;
                Results = subject{1};
                ALLRESULTS = [ALLRESULTS; Results];
                run results_setup;

                da_1 = []; da_2 = []; da_3 = []; da_4 = [];
                Rdist=[];Cdist=[];distractors=[];
                
                %check for exclusion (given 32 trials per block)
%                 if conds == 9 %% needs to be conds 0 and 1 combined
%                     for block = 1:max(blockNum)
%                         nono = 0;
%                         x = block * 32 - 32;
%                         for i = 1+x:32+x
%                             if confValues(i) == 1 || confValues2(i) == 1
%                                 nono = nono+1;
%                             end
%                         end
%                         if nono > 27
%                             disp(pop);
%                             disp('EXCLUDE!');
%                         end
%                     end
%                 end
                    
                for i = 1:length(trialNum)
                    if (confLevel == 1 && totalConf(i) < M) || (confLevel == 2 && totalConf(i) > M) || (confLevel == 3)
                        if saccade(i) == analyzeSac || conds == 9 || conds == 7 %7 stands for no saccade conditions, 9 stands for all conditions
                            if saccade(i) > 1
                                Rdist = [Rdist; 90];
                                Cdist = [Cdist; -90];   
                            else
                                Rdist = [Rdist; 0];
                                Cdist = [Cdist; 0];   
                            end
                            
                            totvar = [totvar; saccadeTime(i)];
                            
                            if saccade(i) == 0 % no saccade, 50 ms
                                da_1 = [da_1; col_diff(i)];
                            elseif saccade(i) == 1 % no saccade, 500 ms
                                da_2 = [da_2; col_diff(i)];
                            elseif saccade(i) == 2 % saccade, 50 ms
                                da_3 = [da_3; col_diff(i)];
                            elseif saccade(i) == 3 % saccade, 5000 ms
                                da_4 = [da_4; col_diff(i)];
                            end
                        end
                    end
                end
                

                distractors(1,:) = Rdist;
                distractors(2,:) = Cdist;
                
                switch analyzeSac
                    case 0
                        da_a = [da_1];
                    case 1
                        da_a = [da_2];
                    case 2
                        da_a = [da_3];
                    case 3
                        da_a = [da_4];
                end
                if conds == 9
                    da_a = [da_1; da_2; da_3; da_4];
                end
                if conds == 7
                    da_a = [da_1; da_2];
                end

                datasets_a.errors = da_a;
                datasets_a.subjectID = 1;
                datasets_a.distractors = distractors;
                data_a{1} = datasets_a;

                disp(['subject avg total err: ', num2str(nanmean(col_diff))]);
                disp(['this condition''s avg err: ', num2str(nanmean(da_a))]);
                toterr = [toterr; nanmean(da_a)];
                

                fit = MemFit(data_a{1},model2);

                global falseConverge
                while falseConverge %if subject didn't converge, try again (diff start points may have gotten caught in different local minimums)
                    fit = MemFit(data_a{1},model2);
                end

                cd (saveDir)
                set(gcf, 'Position', [0 0 400 600]);

                if confLevel == 1
                    savefig(['model',num2str(model),'_subject_highConf_c',num2str(analyzeSac),'_', num2str(pop)]);
                    save(['model',num2str(model),'_subject_highConf_c',num2str(analyzeSac),'_',num2str(pop),'fit.mat'],'fit');
                    print(['model',num2str(model),'_subject_highConf_c',num2str(analyzeSac),'_',num2str(pop)],'-dpng');
                    close all
                elseif confLevel == 2
                    savefig(['model',num2str(model),'_subject_lowConf_c',num2str(analyzeSac),'_', num2str(pop)]);
                    save(['model',num2str(model),'_subject_lowConf_c',num2str(analyzeSac),'_',num2str(pop),'fit.mat'],'fit');
                    print(['model',num2str(model),'_subject_lowConf_c',num2str(analyzeSac),'_',num2str(pop)],'-dpng');
                    close all
                elseif confLevel == 3
                    savefig(['model',num2str(model),'_subject_c',num2str(analyzeSac),'_',num2str(pop)]);
                    save(['model',num2str(model),'_subject_c',num2str(analyzeSac),'_',num2str(pop),'fit.mat'],'fit');
                    print(['model',num2str(model),'_condition_',num2str(analyzeSac),'_',num2str(pop)],'-dpng');
                    close all
                end
            end
        end
    end
end