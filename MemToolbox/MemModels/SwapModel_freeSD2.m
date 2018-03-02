% SWAPMODEL returns a structure for a three-component model
% with guesses and swaps. Based on Bays, Catalao, & Husain (2009) model.
% This is an extension of the StandardMixtureModel that allows for
% observers' misreporting incorrect items.
%
% In addition to data.errors, the data struct should include:
%   data.distractors, Row 1: distance of distractor 1 from target
%   ...
%   data.distractors, Row N: distance of distractor N from target
%
% Note that these values are the *distance from the correct answer*, not
% the actual color values of the distractors. They should thus range from
% -180 to 180.
%
% data.distractors may contain NaNs. For example, if you have data with
% different set sizes, data.distractors should contain as many rows as you
% need for the largest set size, and for displays with smaller set sizes
% the last several rows can be filled with NaNs.
%
% This model includes a custom .modelPlot function that is called by
% MemFit(). This function produces a plot of the distance of observers'
% reports from the distractors, rather than from the target, as in Bays,
% Catalao & Husain (2009), Figure 2B.
%
% A prior probability distribution can be specified in model.prior. Example
% priors are available in MemModels/Priors.
%
function model = SwapModel_freeSD()
  model.name = 'Swap model freeSD';
	model.paramNames = {'muT', 'g', 'FQ', 'RQ', 'sdT', 'sdD'};
	model.lowerbound = [-50 0 0 0 0 0]; % Lower bounds for the parameters
	model.upperbound = [50 1 1 1 120 90]; % Upper bounds for the parameters (90 for sdD because FQ and RQ shouldn't intersect, 120 for sdT bc we exclude if over 90)
	model.movestd = [1, 0.02, 0.02, 0.02, 0.1, 0.1];
    model.pdf = @SwapModelPDF;
    model.modelPlot = @model_plot;
    model.generator = @SwapModelGenerator;
    model.start =   [0, 0.35, 0.01, 0.39, 20, 30;  % muT, g, FQ, RQ, sdT, sdD
                    10, 0.2, 0.2, 0.2, 40, 50; 
                    -10, 0.5, 0.3, 0.1, 60, 70]; 

  % To specify a prior probability distribution, change and uncomment
  % the following line, where p is a vector of parameter values, arranged
  % in the same order that they appear in model.paramNames:
  % model.prior = @(p) (1);

  % Use our custom modelPlot to make a plot of errors centered on
  % distractors (ala Bays, Catalao & Husain, 2009, Figure 2B)
  function figHand = model_plot(data, params, varargin)
    d.errors = [];
    for i=1:length(data.errors)
      d.errors = [d.errors; circdist(data.errors(i), data.distractors(:,i))];
    end
    if isstruct(params) && isfield(params, 'vals')
      params = MCMCSummarize(params, 'maxPosterior');
    end
    m = StandardMixtureModel();
    f = [1-(params(2)/size(data.distractors,1)) params(3)];
    figHand = PlotModelFit(m, f, d, 'NewFigure', true, 'ShowNumbers', false);
    title('Error relative to distractor locations', 'FontSize', 14);
    topOfY = max(ylim);
    txt = sprintf('B: %.3f\nsd: %0.2f\n', params(2), params(3));
    text(180, topOfY-topOfY*0.05, txt, 'HorizontalAlignment', 'right');
  end
end

function p = SwapModelPDF(data, muT, g, FQ, RQ, sdT, sdD)
  % Parameter bounds check
  if g+FQ+RQ > 1
    p = zeros(size(data.errors));
    return;
  end

  if(~isfield(data, 'distractors'))
    error('The swap model requires that you specify the distractors.')
  end
  
  p = (1-g-FQ-RQ).*vonmisespdf(data.errors(:),muT,deg2k(sdT)) + ...
      (FQ).*vonmisespdf(data.errors(:),data.distractors(2,:)',deg2k(sdD)) + ...
      (RQ).*vonmisespdf(data.errors(:),data.distractors(1,:)',deg2k(sdD)) + ...
          (g).*unifpdf(data.errors(:), -180, 180);
end

% Swap model random number generator
function y = SwapModelGenerator(params,dims,displayInfo)
  n = prod(dims);

  % Assign types to trials
  r = rand(n,1);
  which = zeros(n,1); % default = remembered
  numDistractorsPerTrial = sum(~isnan(displayInfo.distractors),1)';
  which(r<params{1}+params{2}) = ceil(rand(sum(r<params{1}+params{2}), 1) ...
    .* numDistractorsPerTrial(r<params{1}+params{2})); % swap to random distractor
  which(r<params{1}) = -1; % guess

  % Fill in with errors
  y = zeros(n,1);
  y(which==-1) = rand(sum(which==-1), 1)*360 - 180;
  y(which==0)  = vonmisesrnd(0,deg2k(params{3}), [sum(which==0) 1]);

  for d=1:size(displayInfo.distractors,1)
    y(which==d) = vonmisesrnd(displayInfo.distractors(d,(which==d))', ...
      deg2k(params{3}), [sum(which==d) 1]);
  end

  % Reshape
  y = reshape(y,dims);
end
