% set up variables from dataset Results
blockNum = cell2mat(Results(:,4));
trialNum = cell2mat(Results(:,5));
saccade = cell2mat(Results(:,7)); 
retino = cell2mat(Results(:,8));
position = cell2mat(Results(:,11));
UL = cell2mat(Results(:,19));
UR = cell2mat(Results(:,20));
LL = cell2mat(Results(:,21));
LR = cell2mat(Results(:,22));
testColor = cell2mat(Results(:,23));
reportedColor = cell2mat(Results(:,24));
col_diff = cell2mat(Results(:,25));
randrotate = cell2mat(Results(:,29));
flip = cell2mat(Results(:,30));
saccadeTime = cell2mat(Results(:,38));

for i = 1:size(Results,1)
    confValues(i)  = length(cell2mat((Results(i,26))));
    confValues2(i) = length(cell2mat((Results(i,27))));
    totalConf(i) = confValues(i)+confValues2(i);
    switch retino(i)
        case 1
            ret(i) = UL(i);
            ctr(i) = within360(ret(i) + 180);
        case 2 
            ret(i) = UR(i);
            ctr(i) = within360(ret(i) + 180);
        case 3 
            ret(i) = LL(i);
            ctr(i) = within360(ret(i) + 180);
        case 4
            ret(i) = LR(i);
            ctr(i) = within360(ret(i) + 180);
    end
    if position(i) == retino(i)
        ret(i) = testColor(i) + 90;
        ctr(i) = testColor(i) - 90;
    end
    if abs(wrap360(ret(i), reportedColor(i))) < abs(wrap360(ctr(i), reportedColor(i)))
        col_diff(i) = abs(wrap360(testColor(i), reportedColor(i)));
    else
        col_diff(i) = - abs(wrap360(testColor(i), reportedColor(i)));
    end
    
%     if position(i) == retino(i)
%         ret(i) = testColor(i) + 90;
%         ctr(i) = testColor(i) - 90;
%     end
%     [c,f] = closer_farther(testColor(i),reportedColor(i),ret(i));
%     if c
%         col_diff(i) = abs(wrap360(testColor(i), reportedColor(i)));
%     elseif f
%         col_diff(i) = - abs(wrap360(testColor(i), reportedColor(i)));
%     end
    
end
startingcolor = cell2mat(Results(:,28)); 
M = median(totalConf);

% disp(['avg time: ', num2str(nanmean(time))]);

