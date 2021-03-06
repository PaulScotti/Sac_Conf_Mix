%% Continuous asymmetrical confidence response
randrotate = randi(360);
flip = randi(2);


flip = 2;


prefs = getPreferences(screenCenterX,screenCenterY,randrotate,flip,fullcolormatrix);
colorWheelLocations = colorwheelLocations(window,prefs);
fullcolormatrixFlip = flipud(fullcolormatrix);
asymType = 1;
startingcolor = nan;

% buttons will be empty if no mouse click, need to reset every trial
buttons = [];

% Wait for click.
SetMouse(screenCenterX, screenCenterY, screenNumber, mouseNum);
ShowCursor('Arrow');

% If mouse button is already down, wait for release.
GetMouse(window);
while any(buttons)
[x, y, buttons] = GetMouse(window);
end
everMovedFromCenter = false;

startReport = GetSecs;
while ~any(buttons)
    drawColorWheel(window, prefs);
    [x,y,buttons] = GetMouse(window);
    [minDistance, minDistanceIndex] = min(sqrt((colorWheelLocations(1, :) - x).^2 + (colorWheelLocations(2, :) - y).^2));

    if(minDistance < 250)
      everMovedFromCenter = true;
      startingcolor = mod(minDistanceIndex + randrotate,360);
    end

    if(everMovedFromCenter)
        clickAngle = mod(minDistanceIndex,360);
    else
        clickAngle = 0;
    end
    
    if flip == 1
        trueAngle = mod(testColor - randrotate,360);
    elseif flip == 2
        trueAngle = - mod(testColor + randrotate,360);
    end
    trueClickX = cosd(trueAngle).*prefs.colorWheelRadius + prefs.cx;
    trueClickY = sind(trueAngle).*prefs.colorWheelRadius + prefs.cy;

    lastClickX = cosd(clickAngle).*prefs.colorWheelRadius + prefs.cx;
    lastClickY = sind(clickAngle).*prefs.colorWheelRadius + prefs.cy;

    drawColorWheel(window, prefs);

    Screen('FillOval', window, [225 225 225], CenterRectOnPointd([0 0 30 30], lastClickX, lastClickY), 10);

    madeClick1 = Screen('Flip', window);
end

%calculate reported color
if flip == 1
    reportedcolor = mod(minDistanceIndex + randrotate,360);
elseif flip == 2
    try
        reportedcolor = within360(- mod(minDistanceIndex + randrotate,360));
    catch
        reportedcolor = - mod(minDistanceIndex + randrotate,360);
    end
end
if reportedcolor == 0
    reportedcolor = 360;
end

while any(buttons) % wait for release
[x,y,buttons] = GetMouse(window);
end

%% Confidence ring part 1
% If mouse button is already down, wait for release.
GetMouse(window);
while any(buttons)
[x, y, buttons] = GetMouse(window);
end
everMovedFromCenter = false;  

while ~any(buttons)     
    [x,y,buttons] = GetMouse(window);
    [minDistance, minDistanceIndex] = min(sqrt((colorWheelLocations(1, :) - x).^2 + (colorWheelLocations(2, :) - y).^2));

    if(minDistance < 250)
      everMovedFromCenter = true;
    end

    if(everMovedFromCenter)
        futureclickAngle = mod(minDistanceIndex,360);
    else
        futureclickAngle = 0;
    end

    clickAngle = within360(clickAngle);

    if futureclickAngle == 0
        confValues = clickAngle;
    elseif wrap360(clickAngle,futureclickAngle) < 0
        if futureclickAngle > clickAngle+wrap360(futureclickAngle,clickAngle)
            clickAngle = clickAngle + 360;
        end
        confValues = within360(futureclickAngle:clickAngle);
        asymType = 1;
    elseif wrap360(clickAngle,futureclickAngle) > 0
        if clickAngle+wrap360(futureclickAngle,clickAngle) > futureclickAngle
            futureclickAngle = futureclickAngle + 360;
        end
        confValues = within360(clickAngle:futureclickAngle);
        asymType = 2;
    else
        confValues = clickAngle;
    end
    asymmetric = wrap360(clickAngle,futureclickAngle);

    %draw ring surrounding confidence
    if flip == 1
        Screen('DrawDots', window, colorWheelLocations(:,confValues), 40, [0 0 0], [], 1);
    elseif flip == 2
        Screen('DrawDots', window, colorWheelLocations(:,confValues), 40, [0 0 0], [], 1);
    end
    
    % draw color wheel
    drawColorWheel(window, prefs);
    
    %draw where last click was
    if flip == 1
        Screen('FillOval', window, fullcolormatrix(reportedcolor,:), CenterRectOnPointd([0 0 30 30], lastClickX, lastClickY), 10);
    elseif flip == 2
        Screen('FillOval', window, fullcolormatrix(reportedcolor,:), CenterRectOnPointd([0 0 30 30], lastClickX, lastClickY), 10);
    end
    
    madeClick2 = Screen('Flip', window);
end

while any(buttons) % wait for release
[x,y,buttons] = GetMouse(window);
end

%% Confidence ring part 2
% If mouse button is already down, wait for release.
GetMouse(window);
while any(buttons)
[x, y, buttons] = GetMouse(window);
end
everMovedFromCenter = false;  

while ~any(buttons)     
    [x,y,buttons] = GetMouse(window);
    [minDistance, minDistanceIndex] = min(sqrt((colorWheelLocations(1, :) - x).^2 + (colorWheelLocations(2, :) - y).^2));

    if(minDistance < 250)
      everMovedFromCenter = true;
    end

    if(everMovedFromCenter)
        futureclickAngle = mod(minDistanceIndex,360);
    else
        futureclickAngle = 0;
    end
    
    clickAngle = within360(clickAngle);

    if futureclickAngle == 0
        confValues2 = clickAngle;
    elseif asymType == 2
        if wrap360(clickAngle,futureclickAngle) < 0 || wrap360(clickAngle,futureclickAngle) > asymmetric
            if futureclickAngle > clickAngle+wrap360(futureclickAngle,clickAngle)
                clickAngle = clickAngle + 360;
            end
            confValues2 = within360(futureclickAngle:clickAngle);
        else
            confValues2 = clickAngle;
        end
    elseif asymType == 1 
        if wrap360(clickAngle,futureclickAngle) > 0 || wrap360(clickAngle,futureclickAngle) < asymmetric
            if clickAngle+wrap360(futureclickAngle,clickAngle) > futureclickAngle
                futureclickAngle = futureclickAngle + 360;
            end
            confValues2 = within360(clickAngle:futureclickAngle);
        else
            confValues2 = clickAngle;
        end
    else
        confValues2 = clickAngle;
    end

    %draw previous ring surrounding confidence
    if flip == 1
        Screen('DrawDots', window, colorWheelLocations(:,confValues), 40, [0 0 0], [], 1);
    elseif flip == 2
        Screen('DrawDots', window, colorWheelLocations(:,confValues), 40, [0 0 0], [], 1);
    end
    
    %draw new ring surrounding confidence
    if flip == 1
        Screen('DrawDots', window, colorWheelLocations(:,confValues2), 40, [0 0 0], [], 1);
    elseif flip == 2
        Screen('DrawDots', window, colorWheelLocations(:,confValues2), 40, [0 0 0], [], 1);
    end
    
    % draw color wheel
    drawColorWheel(window, prefs);
    
    %draw where last click was
    if flip == 1
        Screen('FillOval', window, fullcolormatrix(reportedcolor,:), CenterRectOnPointd([0 0 25 25], lastClickX, lastClickY), 10);
    elseif flip == 2
        Screen('FillOval', window, fullcolormatrix(reportedcolor,:), CenterRectOnPointd([0 0 25 25], lastClickX, lastClickY), 10);
    end
    
    %draw where last click was
    Screen('FillOval', window, fullcolormatrix(reportedcolor,:), CenterRectOnPointd([0 0 30 30], lastClickX, lastClickY), 10);
    
    madeClick3 = Screen('Flip', window);
end

%% Feedback 
HideCursor;

%calculate difference
flip
col_diff = wrap360(testColor, reportedcolor)    


switch retino
    case 1
        ret = UL;
        ctr = within360(ret + 180);
    case 2 
        ret = UR;
        ctr = within360(ret + 180);
    case 3 
        ret = LL;
        ctr = within360(ret + 180);
    case 4
        ret = LR;
        ctr = within360(ret + 180);
end
if position == retino
    ret = testColor + 90;
    ctr = testColor - 90;
end
if abs(wrap360(ret, reportedcolor)) < abs(wrap360(ctr, reportedcolor))
    col_diff = abs(wrap360(testColor, reportedcolor));
else
    col_diff = - abs(wrap360(testColor, reportedcolor));
end
col_diff

%draw previous ring
if flip == 1
    Screen('DrawDots', window, colorWheelLocations(:,confValues), 40, [0 0 0], [], 1);
elseif flip == 2
    Screen('DrawDots', window, colorWheelLocations(:,confValues), 40, [0 0 0], [], 1);
end

%draw second ring surrounding confidence
if flip == 1
    Screen('DrawDots', window, colorWheelLocations(:,confValues2), 40, [0 0 0], [], 1);
elseif flip == 2
    Screen('DrawDots', window, colorWheelLocations(:,confValues2), 40, [0 0 0], [], 1);
end

%draw color wheel
drawColorWheel(window, prefs);

%draw where last click was
Screen('FillOval', window, fullcolormatrix(reportedcolor,:), CenterRectOnPointd([0 0 30 30], lastClickX, lastClickY), 10);

% Show original color
Screen('FillOval', window, fullcolormatrix(testColor,:), CenterRectOnPointd([0 0 75 75], trueClickX, trueClickY), 10);
Screen('FrameOval', window, [255 255 255], CenterRectOnPointd([0 0 75 75], trueClickX, trueClickY), 2);

Screen('Flip', window);

WaitSecs(1);

