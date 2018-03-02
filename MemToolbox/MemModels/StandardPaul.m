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
function model = StandardPaul()
  model.name = 'Standard Mixture Model w Bias (ps)';
	model.paramNames = {'muT', 'g', 'sdT'};
	model.lowerbound = [-50 0 0]; % Lower bounds for the parameters
	model.upperbound = [50 1 90]; % Upper bounds for the parameters
	model.movestd = [1 0.02, 0.1];
  model.pdf = @SwapModelPDF;
  model.modelPlot = @model_plot;
  model.generator = @SwapModelGenerator;
	model.start = [0, 0.3, 10;  % muT, g, sdT
    10, 0.2, 20; 
    -10, 0.6, 30]; 

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

function p = SwapModelPDF(data, muT, g, sdT)
  % Parameter bounds check
  if g > 1
    p = zeros(size(data.errors));
    return;
  end

  % This could be vectorized entirely but would be less clear; but I assume
  % people will rarely have greater than 8 or so distractors, so the loop
  % is over a relatively small dimension
  
  p = (1-g).*vonmisespdf(data.errors(:),muT,deg2k(sdT)) + ...
          (g).*unifpdf(data.errors(:), -180, 180);
end
