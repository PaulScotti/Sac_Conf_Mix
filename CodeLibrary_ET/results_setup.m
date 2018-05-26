% set up variables from dataset Results

randrotate = cell2mat(Results(:,6)); 
BlockType = cell2mat(Results(:,3)); %2 = 1st half; 3 = 2nd half
TestPhase = cell2mat(Results(:, 10)); 
ReportedColor = cell2mat(Results(:,15)); 
OrigColor = cell2mat(Results(:,14)); 
OrigSeed = cell2mat(Results(:, 17)); 
% OrigTrial = cell2mat(Results(:,29));
Seed1 = cell2mat(Results(:, 25)); 
Seed2 = cell2mat(Results(:, 26)); 
Seed3 = cell2mat(Results(:, 27)); 
Seed4 = cell2mat(Results(:, 28)); 
flipper = cell2mat(Results(:,end));
time = cell2mat(Results(:,21));
% conf = cell2mat(Results(:,30));

disp(['avg time: ', num2str(nanmean(time))]);

for i = 1:length(Results(:,16))
    if isempty(cell2mat(Results(i,16)))
        Results(i,16) = num2cell(nan);
    end
end
coldiff = cell2mat(Results(:,16));
truemean = cell2mat(Results(:, 2));

% M = nanmedian(conf);

for i = 1:length(ReportedColor)
    if isnan(ReportedColor(i)) || isnan(coldiff(i)) || isnan(cell2mat(Results(i,16)))
        randrotate(i) = nan;
        BlockType(i) = nan;
        TestPhase(i) = nan;
        ReportedColor(i) = nan;
        OrigColor(i) = nan;
        OrigSeed(i) = nan;
        Seed1(i) = nan;
        Seed2(i) = nan;
        Seed3(i) = nan;
        Seed4(i) = nan;
        coldiff(i) = nan;
        truemean(i) = nan;
        time(i) = nan;
%         conf(i) = nan;
%         OrigTrial(i) = nan;
    end
end

randrotate = randrotate(~isnan(randrotate));
BlockType = BlockType(~isnan(BlockType));
TestPhase = TestPhase(~isnan(TestPhase));
ReportedColor = ReportedColor(~isnan(ReportedColor));
OrigColor = OrigColor(~isnan(OrigColor));
OrigSeed = OrigSeed(~isnan(OrigSeed));
Seed1 = Seed1(~isnan(Seed1));
Seed2 = Seed2(~isnan(Seed2));
Seed3 = Seed3(~isnan(Seed3));
Seed4 = Seed4(~isnan(Seed4));
coldiff = coldiff(~isnan(coldiff));
truemean = truemean(~isnan(truemean));
errors = coldiff;
time = time(~isnan(time));

% conf = conf(~isnan(conf));
% OrigTrial = OrigTrial(~isnan(OrigTrial));

% for i = 1:length(ReportedColor)
%     errors(i) = wrap360(OrigColor(i), ReportedColor(i));
% end


