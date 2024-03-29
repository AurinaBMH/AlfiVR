function dataALL = collect_validity_data()

% This function will load data and make a big table for all validity data
% This function is a copy of collect_data, aims to compose same output, but
% for validity data-sets. These should be stored in data/validity-analytics
% folder
% Dan - 2022-09-22

% -----------------------------------------------------------------------------
% INPUT:
% no input required, should be run from the root directory - all paths are
% relative
% -----------------------------------------------------------------------------

% -----------------------------------------------------------------------------
% OUTPUT:
% dataALL - table containing all data within data/analytics folder
% -----------------------------------------------------------------------------

% Create OS agnostic path to project directory
projDir = dir();
projDir = projDir(1).folder;

% select where to take the data from
fileList = dir(fullfile(projDir, 'data', 'validity-analytics'));

% where to put the data

% Check if excel subdirectory is present, if not create it
if ~exist(fullfile(projDir, 'data', 'excel'), 'dir')  
    mkdir(fullfile(projDir, 'data', 'excel'));
end

% Check if csv subdirectory is present, if not create it
if ~exist(fullfile(projDir, 'data', 'csv'), 'dir')  
    mkdir(fullfile(projDir, 'data', 'csv'));
end

fileOut = dir(fullfile(projDir, 'data', 'excel'));
fileOut = fileOut(1).folder;

% these should be separate if statements, can't be combined with the other
if isempty(fileOut)
    warning 'data/excel directory not found, run the function from the root directory'
end

if isempty(fileList)
    warning 'data/validity-analytics directory not found, run the function from the root directory'
    warning 'place .analytics files in data/validity-analytics'
    return
else
    % for each file, select only '.analytics'
    isAN = zeros(length(fileList),1); 
    for n = 1:length(fileList)
        isAN(n) = contains(fileList(n).name, '.analytics'); 
    end
    fileList = fileList(isAN==1,:);

    % measures to be extracted;
    whatMeasures = {'SessionNumber', 'Block', 'Trial', 'Trial_Type', ...
        'Stop_Signal_Left', 'Stop_Signal_Right', 'Cue_Type', 'Safe_Response_Range', ...
        'Cue_Accuracy', 'Adaptive_Stop_Signal_Offset', 'Left_Stop_Signal_Delay', 'Right_Stop_Signal_Delay',	...
        'responseTimeLeft', 'responseTimeRight', 'Avg_RespTime', 'L_R_Synchrony'};
    
    % loop over all of the files in the "data" folder:
    dataSubject = cell(length(fileList),1);
    for s = 1:length(fileList)

        fname = fileList(s).name;

            % Get the data out of the .analytics file
            alfi_sess = convert_timeStamps(fname);
            numBlocks = length(alfi_sess.GameAnalytics.DragonSST.Blocks);
            
            % this cell saves all data from one session
            dataSession = cell(numBlocks,1);
            
            for b = 1:numBlocks
                
                numTrials = size(alfi_sess.GameAnalytics.DragonSST.Blocks(b).Trials,1);
                % this table will contain data for one selected block
                data = table;
                
                % add a variable for subject, e.g. file name
                [subName{1:numTrials}] = deal(fname);
                data.File = subName';
                
                % loop over selected measures and extract corresponding values
                for m=1:length(whatMeasures)
                    
                    switch whatMeasures{m}
                        case 'SessionNumber'
                            % add the same session for all elements
                            data.(whatMeasures{m}) = repmat(alfi_sess.SessionNumber, numTrials,1);
                            
                        case 'Block'
                            % add the same block for all elements
                            data.(whatMeasures{m}) = repmat(b, numTrials,1);
                            
                        case 'Trial'
                            % variable for trials
                            data.(whatMeasures{m}) = linspace(1,numTrials, numTrials)';
                            
                        case {'Trial_Type', 'Stop_Signal_Left', 'Stop_Signal_Right', 'Cue_Type'}
                            % these are all strings and will remain strings
                            % loop over trials and extract information
                            selectData = strings(numTrials,1);
                            for t=1:numTrials
                                if ~isempty(alfi_sess.GameAnalytics.DragonSST.Blocks(b).Trials(t).(whatMeasures{m}))
                                    selectData(t) = alfi_sess.GameAnalytics.DragonSST.Blocks(b).Trials(t).(whatMeasures{m});
                                end
                            end
                            % add variables to table;
                            data.(whatMeasures{m}) = selectData;
                            
                        case {'Left_Stop_Signal_Delay', 'Right_Stop_Signal_Delay'}
                            % convert time stamp to number in ms
                            selectData = nan(numTrials,1);
                            for t=1:numTrials
                                if ~isempty(alfi_sess.GameAnalytics.DragonSST.Blocks(b).Trials(t).(whatMeasures{m}))
                                    
                                    timeStamp = alfi_sess.GameAnalytics.DragonSST.Blocks(b).Trials(t).(whatMeasures{m});
                                    % select elements and convert to ms
                                    STAMP_temp = split(timeStamp, ':');
                                    selectData(t) = (str2double(STAMP_temp{1})*3600 + ...
                                        str2double(STAMP_temp{2})*60 + ...
                                        str2double(STAMP_temp{3}))*1000;
                                    
                                end
                            end
                            % add variables to table;
                            data.(whatMeasures{m}) = selectData;

                        case {'Avg_RespTime', 'L_R_Synchrony'}
                            % calculate those based on L/R response times;
                            selectData = nan(numTrials,1);
                            
                            for t=1:numTrials
                                % if both responses exist
                                if ~isempty(alfi_sess.GameAnalytics.DragonSST.Blocks(b).Trials(t).responseTimeRight) && ...
                                        ~isempty(alfi_sess.GameAnalytics.DragonSST.Blocks(b).Trials(t).responseTimeLeft)
                                    
                                    if strcmp(whatMeasures{m}, 'Avg_RespTime')
                                        % take the mean of L and R
                                        selectData(t) = mean([alfi_sess.GameAnalytics.DragonSST.Blocks(b).Trials(t).responseTimeRight,...
                                            alfi_sess.GameAnalytics.DragonSST.Blocks(b).Trials(t).responseTimeLeft]);
                                    elseif strcmp(whatMeasures{m}, 'L_R_Synchrony')
                                        % R-L in this case
                                        selectData(t) = alfi_sess.GameAnalytics.DragonSST.Blocks(b).Trials(t).responseTimeRight - ...
                                            alfi_sess.GameAnalytics.DragonSST.Blocks(b).Trials(t).responseTimeLeft;
                                    end
                                    
                                end
                            end
                            % add variables to table;
                            data.(whatMeasures{m}) = selectData;
                            
                        otherwise
                            % for all others, keep them as number
                            selectData = nan(numTrials,1);
                            for t=1:numTrials
                                if ~isempty(alfi_sess.GameAnalytics.DragonSST.Blocks(b).Trials(t).(whatMeasures{m}))
                                    
                                    selectData(t) = alfi_sess.GameAnalytics.DragonSST.Blocks(b).Trials(t).(whatMeasures{m});
                                    
                                end
                            end
                            % add variables to table;
                            data.(whatMeasures{m}) = selectData;
                    end
                    
                end
                % data for each block added to the session cell
                dataSession{b} = data;
                clear subName  
            end
            % data from each file placed into a cell (these will be vertcat later)
            dataSubject{s} = vertcat(dataSession{:});

    end
    % combine subject data into one big table
    dataALL = vertcat(dataSubject{:});
end
 writetable(dataALL, fullfile(projDir, 'data', 'excel', 'ALFIdata_VALIDITY.xlsx'),'Sheet',1);
 writetable(dataALL, fullfile(projDir, 'data', 'csv', 'ALFIdata_VALIDITY.csv'));
end
