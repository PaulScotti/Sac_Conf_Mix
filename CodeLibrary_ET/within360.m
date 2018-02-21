function degree = within360(input)
    for i = 1:length(input)
        if input(i) <= 0 
            degree(i) = input(i)+360;
        elseif input(i) > 360
            degree(i) = input(i)-360;
        else
            degree(i) = input(i);
        end
    end
end
