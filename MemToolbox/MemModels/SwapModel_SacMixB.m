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
function model = SwapModel_SacMix()
  model.name = 'SwapModel_SacMix';
	model.paramNames = {'R', 'C', 'sdT', 'sdR', 'sdC',};
	model.lowerbound = [0 0 0 0 0]; % Lower bounds for the parameters
	model.upperbound = [1 1 120 90 90]; % Upper bounds for the parameters (120 because >90 is exclusion criterion)
	model.movestd = [0.02, 0.02, 0.1, 0.1, 0.1];
    model.pdf = @SwapModelPDF;
    model.modelPlot = @model_plot;
    model.generator = @SwapModelGenerator;
    model.start =   [0.1, 0.3, 10, 30, 10;  %R, C, sdT, sdR, sdC
                    0.2, 0.2, 20, 20, 20; 
                    0.3, 0.1, 30, 10, 30]; 

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

function p = SwapModelPDF(data, R, C, sdT, sdR, sdC)
  % Parameter bounds check
  if R+C > 1
    p = zeros(size(data.errors));
    return;
  end

  if(~isfield(data, 'distractors'))
    error('The swap model requires that you specify the distractors.')
  end
  
  p = (1-C-R).*vonmisespdf(data.errors(:),0,deg2k(sdT)) + ...
      (R).*vonmisespdf(data.errors(:),90,deg2k(sdR)) + ...
      (C).*vonmisespdf(data.errors(:),-90,deg2k(sdC));
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
