data = Results(:,22);
cond = Results(:,13);

data_r = []; data_p = [];
for i = 1:length(data)
    try
        if cell2mat(cond(i)) == 0
            data_p = [data_p; cell2mat(data(i))];
        elseif cell2mat(cond(i)) == 1
            data_r = [data_r; cell2mat(data(i))];
        end
    end
end