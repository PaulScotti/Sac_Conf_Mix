function L = colorwheelLocations(window,prefs)
  L = [cosd(1:360).*prefs.colorWheelRadius + prefs.cx; ...
       sind(1:360).*prefs.colorWheelRadius + prefs.cy];
end