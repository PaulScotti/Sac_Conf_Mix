function drawColorWheel(window, conf, prefs)
  colorWheelLocations = [cosd(1:360).*prefs.colorWheelRadius + prefs.cx; ...
    sind(1:360).*prefs.colorWheelRadius + prefs.cy];
  colorWheelSizes = 20;
  if conf == 0
     Screen('DrawDots', window, colorWheelLocations, colorWheelSizes, prefs.colorwheel', [], 1); 
  elseif conf == 1
    Screen('DrawDots', window, colorWheelLocations, colorWheelSizes, prefs.colorwheel'-360, [], 1); 
  end
end