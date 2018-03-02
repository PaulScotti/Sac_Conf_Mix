% Sizing information 

% Distance from screen: 61cm 
% Width of screen = 40cm  
% Height of screen = 30cm
% Screen diagonal = 51cm 
% PPD = 35.2565 pixels	(70.5129 on laptop, 52.8847 on external monitor)
% DPP = .0284º 	(.0142º on laptop, .0189 on external monitor)

% In pixels
pixels.perDegree = PPD; 
pixels.monitorX = xsize;
pixels.monitorY = ysize;  
pixels.fixationDeviation = fixlossrad; 
pixels.fixationPoint = fixationSize; 
pixels.fixationSquare = stimRectWidth / 3; 
pixels.cue =  2 * memCueDim; 
pixels.probe = pixels.cue; 
pixels.memTest = pixels.cue; 
pixels.ffEcc = cueDist2ff;  
pixels.nfEcc = cueDist2nf;  
pixels.intialGap = intialGap;   
 
% In visual degrees 
degrees.perPixel = DPP; 
degrees.monitorX = pixels.monitorX * DPP; 
degrees.monitorY = pixels.monitorY * DPP;  
degrees.fixationDeviation = pixels.fixationDeviation * DPP; 
degrees.fixationPoint = pixels.fixationPoint * DPP;
degrees.fixationSquare = pixels.fixationSquare * DPP; 
degrees.cue = pixels.cue * DPP;
degrees.probe = pixels.probe * DPP; 
degrees.memTest = pixels.memTest * DPP; 
degrees.ffEcc = pixels.ffEcc * DPP;  
degrees.nfEcc = pixels.nfEcc * DPP;   
degrees.intialGap = pixels.intialGap * DPP;  
 