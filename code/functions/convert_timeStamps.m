function val = convert_timeStamps(fileName, whatResponse)

if nargin < 2
    whatResponse = 'all';
    fprintf('Giving %s responses BY DEFAULT\n', whatResponse)
end

% This function converts time-stamps to ms and gives resonse time for left
% and right side separately for any trial (GO or STOP) if there is a response
% Aurina Arnatkeviciute 2020/07/24

% -----------------------------------------------------------------------------
% INPUT: 
% fileName - .analytics file name for each sesstion
% whatResponse - what responses to consider: 
% onlySTOP - will give values for only STOP responses; 
% all - will give values for all Premature/Early/Safe/Late responses
% -----------------------------------------------------------------------------

% -----------------------------------------------------------------------------
% OUTPUT: 
% val - the whole data structure with added columns 
% val.GameAnalytics.DragonSST.Blocks(b).Trials(t).responseTimeRight
% val.GameAnalytics.DragonSST.Blocks(b).Trials(t).responseTimeLeft
% -----------------------------------------------------------------------------


val = jsondecode(fileread(fileName));

% loop over blocks
numBlocks = size(val.GameAnalytics.DragonSST.Blocks,1);
for b=1:numBlocks
    
    % get number of trials in a selected block
    numTrials = size(val.GameAnalytics.DragonSST.Blocks(b).Trials,1);
    
    for t=1:numTrials
        % get timestamps:
        % 1 - start of the trial (i.e. Indicator onset)
        % 2 - stop left
        % 3 - stop right
        
        switch whatResponse
            case 'onlySTOP'
                % if only STOP responses are interesting
                isRESP_left = val.GameAnalytics.DragonSST.Blocks(b).Trials(t).Controller_Analytics.LeftHand.StopReponse;
                isRESP_right = val.GameAnalytics.DragonSST.Blocks(b).Trials(t).Controller_Analytics.RightHand.StopReponse;
                
            case 'all'
                % Uncomment this, if any responses are interesting:
                isRESP_left = val.GameAnalytics.DragonSST.Blocks(b).Trials(t).Controller_Analytics.LeftHand.EarlyReponse || ...
                    val.GameAnalytics.DragonSST.Blocks(b).Trials(t).Controller_Analytics.LeftHand.SafeReponse || ...
                    val.GameAnalytics.DragonSST.Blocks(b).Trials(t).Controller_Analytics.LeftHand.LateReponse || ...
                    val.GameAnalytics.DragonSST.Blocks(b).Trials(t).Controller_Analytics.LeftHand.StopReponse;
                
                isRESP_right = val.GameAnalytics.DragonSST.Blocks(b).Trials(t).Controller_Analytics.RightHand.EarlyReponse || ...
                    val.GameAnalytics.DragonSST.Blocks(b).Trials(t).Controller_Analytics.RightHand.SafeReponse || ...
                    val.GameAnalytics.DragonSST.Blocks(b).Trials(t).Controller_Analytics.RightHand.LateReponse || ...
                    val.GameAnalytics.DragonSST.Blocks(b).Trials(t).Controller_Analytics.RightHand.StopReponse;
                
        end
        % make 3 to store left in {2} and right in {3}
        STAMP = cell(3,1);
        STAMP_ms = cell(3,1);
        % if both hands show responses
        if isRESP_left && isRESP_right
            
            
            STAMP{1} = val.GameAnalytics.DragonSST.Blocks(b).Trials(t).Fireball_Onset_Time;
            STAMP{2} = val.GameAnalytics.DragonSST.Blocks(b).Trials(t).Controller_Analytics.LeftHand.Inputs.ReleaseTimeTime;
            STAMP{3} = val.GameAnalytics.DragonSST.Blocks(b).Trials(t).Controller_Analytics.RightHand.Inputs.ReleaseTimeTime;
            
        elseif isRESP_left
            
            STAMP{1} = val.GameAnalytics.DragonSST.Blocks(b).Trials(t).Fireball_Onset_Time;
            STAMP{2} = val.GameAnalytics.DragonSST.Blocks(b).Trials(t).Controller_Analytics.LeftHand.Inputs.ReleaseTimeTime;
            
        elseif isRESP_right
            
            STAMP{1} = val.GameAnalytics.DragonSST.Blocks(b).Trials(t).Fireball_Onset_Time;
            STAMP{3} = val.GameAnalytics.DragonSST.Blocks(b).Trials(t).Controller_Analytics.RightHand.Inputs.ReleaseTimeTime;
        end
        
        
        % convert those times to ms
        for i=1:length(STAMP)
            % skip, if empty, keeping consistent indexes will be useful later
            if ~isempty(STAMP{i})
                STAMP_temp = split(STAMP{i},'T');
                STAMP_temp = split(STAMP_temp{2}, '+');
                STAMP_temp = split(STAMP_temp{1}, ':'); % this gives hours, mins, sec;
                STAMP_ms{i} = (str2double(STAMP_temp{1})*3600 + ...
                    str2double(STAMP_temp{2})*60 + ...
                    str2double(STAMP_temp{3}))*1000;
            end
        end
        
        % calculate:
        % responseTimeLeft = b - a;
        % responseTimeRight = c - a;
        if isRESP_left
            val.GameAnalytics.DragonSST.Blocks(b).Trials(t).responseTimeLeft = STAMP_ms{2} - STAMP_ms{1};
        end
        
        if isRESP_right
            val.GameAnalytics.DragonSST.Blocks(b).Trials(t).responseTimeRight = STAMP_ms{3} - STAMP_ms{1};
        end
        
    end
end



end