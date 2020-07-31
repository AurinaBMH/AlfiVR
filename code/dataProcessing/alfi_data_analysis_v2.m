% This function will load data and make a big table for each subjects ectracting the relevant information;

fileList = dir('data/analytics');
fileList = fileList(3:length(fileList),:);

%Loop over all of the files in the "data" folder:
for s = 1:length(fileList)
    
    fname = fileList(s).name; 
    
    % Get the data out of the .analytics file
    alfi_sess = convert_timeStamps(fname);
    numBlocks = length(alfi_sess.GameAnalytics.DragonSST.Blocks);
    RT_left = nan(numTrials,blocks); % this will allow to keep missing values, logged as "nan" not a number, as zeros would be misleading as 0 RTs.
    
    for b = 1:numBlocks
        
        numTrials = size(alfi_sess.GameAnalytics.DragonSST.Blocks(b).Trials,1);

        for t=1:numTrials
            if ~isempty(alfi_sess.GameAnalytics.DragonSST.Blocks(b).Trials(t).responseTimeLeft)
                RT_left(t) = alfi_sess.GameAnalytics.DragonSST.Blocks(b).Trials(t).responseTimeLeft;
            end
        end
        
        
        
    end
    
    
    
    
    
    
    
    
    % %Start of the trial (i.e. Indicator onset)
    % a = val.GameAnalytics.DragonSST.Blocks(3).Trials(3).Fireball_Onset_Time
    %
    % %But it is very annoying that all of this is recorded as timestamps. Need a
    % %fancy matlab function to convert from timestamp strings into numbers
    %
    % %ReleaseTime - Fireball_Onset_Time = the response. We need this for the
    % %left and right controllers
    % val.GameAnalytics.DragonSST.Blocks(3).Trials(3).Controller_Analytics.LeftHand.Inputs.PressTimeTime
    % b = val.GameAnalytics.DragonSST.Blocks(3).Trials(3).Controller_Analytics.LeftHand.Inputs.ReleaseTimeTime
    %
    % val.GameAnalytics.DragonSST.Blocks(3).Trials(3).Controller_Analytics.RightHand.Inputs.PressTimeTime
    % c = val.GameAnalytics.DragonSST.Blocks(3).Trials(3).Controller_Analytics.RightHand.Inputs.ReleaseTimeTime
    %
    % %THIS IS WHAT WE NEED FOR EACH TRIAL, could insert as new columns in val.GameAnalytics.DragonSST.Blocks(i).Trials(i)
    % responseTimeLeft = b - a;
    % responseTimeRight = c - a;
    %
    % %Then there is all the stop trial information: See here
    % val.GameAnalytics.DragonSST.Blocks(3).Trials(2).Controller_Analytics.LeftHand
    % val.GameAnalytics.DragonSST.Blocks(3).Trials(2).Controller_Analytics.LeftHand.StopResponse
