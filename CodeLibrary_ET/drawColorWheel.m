function drawColorWheel(window, prefs)
  colorWheelLocations = [cosd(1:360).*prefs.colorWheelRadius + prefs.cx; ...
    sind(1:360).*prefs.colorWheelRadius + prefs.cy];
  colorWheelSizes = 20;
 Screen('DrawDots', window, colorWheelLocations, colorWheelSizes, prefs.colorwheel', [], 1); 
end