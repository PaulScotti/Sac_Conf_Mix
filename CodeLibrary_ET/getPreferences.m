function prefs = getPreferences(cx,cy,randrotate,flip,fullcolormatrix)
  prefs.cx = cx;
  prefs.cy = cy;
  % Colorwheel details.
  prefs.colorWheelRadius = 289.1029; %equivalent to the 16.4 degree diameter from original paper
  prefs.colorwheel = load('colorwheel360.mat', 'fullcolormatrix');
  if flip == 1
    prefs.colorwheel.fullcolormatrix = circshift(prefs.colorwheel.fullcolormatrix,-randrotate);
  elseif flip == 2
    prefs.colorwheel.fullcolormatrix = circshift(flipud(prefs.colorwheel.fullcolormatrix),-randrotate);
  end
  prefs.colorwheel = prefs.colorwheel.fullcolormatrix;
end