clear; clc;
meanfit = []; Rfit = []; Cfit = []; biasedSD=[]; guessfit=[]; targetSD=[];
richSD = []; controlSD = [];
tprop =[]; fqprop = []; rqprop = []; guessprop = []; targetfit = [];
load('degOffs'); incdegoff = [];

% model.paramNames = {'muT','g','sdT'};
% PlotConvergence(fit.posteriorSamples, model.paramNames);

%% Model 1 (All Conditions)
% for person =  [29:36,38,39,41:43]
%     load(['figures and fits/model1_subject_c8_', num2str(person), 'fit.mat']);
%     meanfit = [meanfit; fit.maxPosterior(1)];
%     guessfit = [guessfit; fit.maxPosterior(2)];
%     targetSD = [targetSD; fit.maxPosterior(3)];
%     targetfit = (1 - fit.maxPosterior(2));
%     
%     if guessfit(end) > .5 || targetSD(end) > 90
%         disp(person);
%     end
% end
% meanfit
% mean(meanfit)

%% Model 1
% for person = [29:36,38,39,41:43] %[2,5,8,9:16,18:20,22:23] %[2,5,8,9:16,18:20,22:23]
%     load(['figures and fits/model1_subject_c0_', num2str(person), 'fit.mat']);
%     meanfit = [meanfit; fit.maxPosterior(1)];
%     guessfit = [guessfit; fit.maxPosterior(2)];
%     targetSD = [targetSD; fit.maxPosterior(3)];
%     targetfit = [targetfit; (1 - fit.maxPosterior(2))];
%     
% %     if guessfit(end) > .5 || targetSD(end) > 90
% %         disp(person);
% %     end
% %     model.paramNames = {'muT','g','sdT'};
% %     convPlot = PlotConvergence(fit.posteriorSamples, model.paramNames);
% %     suptitle(['Subject ', num2str(person), '(early sacc)']);
% %     print(['convPlot',num2str(person)],'-dpng');
% end
% meanfit
% mean(meanfit)
% [H,P] = ttest(repmat(0,1,length(meanfit))',meanfit)

%% Model 2
for condition = 0:3
    meanfit = []; Rfit = []; Cfit = []; biasedSD=[]; guessfit=[]; targetSD=[];
    richSD = []; controlSD = []; targetfit = [];
    for person = [29:36,38,39,41:43]
        load(['figures and fits/model2_subject_highConf_c', num2str(condition), '_', num2str(person), 'fit.mat']);
%         load(['figures and fits/model2_subject_c3_', num2str(person), 'fit.mat']);
        Rfit = [Rfit; fit.maxPosterior(1)];
        Cfit = [Cfit; fit.maxPosterior(2)];
        targetSD = [targetSD; fit.maxPosterior(3)];
        richSD = [richSD; fit.maxPosterior(4)];
        controlSD = [controlSD; fit.maxPosterior(5)];
        targetfit = [targetfit; (1 - fit.maxPosterior(1) - fit.maxPosterior(2))];
    end
    data(:,condition+1) = Rfit' - Cfit';
end


%% Model 3
% for person =  [29:36,38,39,41:43]
%     load(['figures and fits/model3_subject_c2_', num2str(person), 'fit.mat']);
%     meanfit = [meanfit; fit.maxPosterior(1)];
%     guessfit = [guessfit; fit.maxPosterior(2)];
%     Rfit = [Rfit; fit.maxPosterior(3)];
%     targetSD = [targetSD; fit.maxPosterior(4)];
%     biasedSD = [biasedSD; fit.maxPosterior(5)];
%     targetfit = (1 - fit.maxPosterior(2) - fit.maxPosterior(3));
% end
% meanfit
% mean(meanfit)
% [H,P] = ttest(repmat(0,1,length(meanfit))',meanfit)

%% Model 4
% for person =  [29:36,38,39,41:43]
%     load(['figures and fits/model4_subject_c2_', num2str(person), 'fit.mat']);
%     meanfit = [meanfit; fit.maxPosterior(1)];
%     guessfit = [guessfit; fit.maxPosterior(2)];
%     Rfit = [Rfit; fit.maxPosterior(3)];
%     Cfit = [Cfit; fit.maxPosterior(4)];
%     targetSD = [targetSD; fit.maxPosterior(5)];
%     biasedSD = [biasedSD; fit.maxPosterior(6)];
%     targetfit = (1 - fit.maxPosterior(2) - fit.maxPosterior(3) - fit.maxPosterior(4));
% end
% meanfit
% mean(meanfit)
% [H,P] = ttest(repmat(0,1,length(meanfit))',meanfit)

