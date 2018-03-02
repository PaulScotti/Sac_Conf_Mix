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
confValues = length((Results(:,26)));
confValues2 = length((Results(:,27)));
startingcolor = cell2mat(Results(:,28)); 

% disp(['avg time: ', num2str(nanmean(time))]);

