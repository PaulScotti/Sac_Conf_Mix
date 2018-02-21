function degree = wrap360(input,comparison) % tells you how far away in degrees comparison is from input
    degree = diff([input comparison]);    
    
    if degree < -180 
        degree = diff([input comparison+360]);
    elseif degree > 180
        degree = diff([input comparison-360]);
    end
end
