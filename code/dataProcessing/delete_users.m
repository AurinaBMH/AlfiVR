function delete_users(exclude)
% ----------------------------------------------------------------------
% [] = delete_users(exclude)
% ----------------------------------------------------------------------
% Goal of the function :
% Deletes specific *.analytics files with specified user names
% ----------------------------------------------------------------------
% Input(s) :
% exclude - Cell array of character containing usernames for test cases
%         - e.g. exclude = {'TEST', 'TEST2'}
% ----------------------------------------------------------------------
% Function created by Dan Myles (dan.myles@monash.edu)
% Last update : September 2022
% Project : ALFI
% Version : 2022a
% ----------------------------------------------------------------------
    
    % Check for function input
    if nargin < 1
        warning(['No input argument', newline ...
                 'Please specify a character cell array of usernames for deletion', newline ...,
                 'See help delete_users']);
        return
    end

    % Create OS agnostic path to project directory
    projDir = dir();
    projDir = projDir(1).folder;
    
    % Check analytics directory exists, else warning
    if ~isdir((fullfile(projDir, 'data', 'analytics')))
        warning 'data/analytics directory not found, run the function from the root directory'
        warning 'run startup() function to create directory structure'
        return
    end
    
    % Get data files
    fileList = dir(fullfile(projDir, 'data', 'analytics', '*.analytics'));
    
    % Check for analytics files
    if isempty(fileList)
        warning 'place .analytics files in data/analytics'
        return
    end
    
    % Get all files
    for i = 1:length(fileList) 
        jsonFiles(i) = jsondecode(fileread(fullfile(fileList(i).folder, fileList(i).name)));
    end
    
    % Add filename to struct
    for i = 1:length(fileList) 
        jsonFiles(i).fname = fileList(i).name;
    end
    
    exclude = jsonFiles(contains({jsonFiles.Name}, exclude));
    
    % Delete excluded files from directory
    for i = 1:length(exclude)
        delete(fullfile(projDir, 'data', 'analytics', exclude(i).fname));
        % Communicate deletion to user
        disp([newline, ...
              'Deleted User:', exclude(i).Name, newline ...
              'Filename: ', exclude(i).fname]);
    end
    
end