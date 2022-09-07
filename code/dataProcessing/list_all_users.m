function userNames = list_all_users()
% ----------------------------------------------------------------------
% userNames = list_all_users()
% ----------------------------------------------------------------------
% Goal of the function :
% Loads all *.analytics files and prints unique user names
% ----------------------------------------------------------------------
% Input(s) : NONE
% ----------------------------------------------------------------------
% Function created by Dan Myles (dan.myles@monash.edu)
% Last update : September 2022
% Project : ALFI
% Version : 2022a
% ----------------------------------------------------------------------

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
        warning 'No *.analytics files found in data/analytics'
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
    
    userNames = unique({jsonFiles.Name})';
    
end