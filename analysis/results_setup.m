% set up variables from dataset Results

trialNum = cell2mat(Results(:,6));
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
for i = 1:length(Results)
    confValues(i)  = length(cell2mat((Results(i,26))));
    confValues2(i) = length(cell2mat((Results(i,27))));
    totalConf(i) = confValues(i)+confValues2(i);
end
startingcolor = cell2mat(Results(:,28)); 
M = median(totalConf);

% disp(['avg time: ', num2str(nanmean(time))]);

