% Add paths required for the project (ignoring hidden, including version control)
function startup()

files = dir; % Get all folders and files at current directory

% Check whether ./data/analytics folder is present in the directory
if ~exist(fullfile(files(1).folder, 'data', 'analytics'), 'dir')  
    % If not create it
    mkdir(fullfile(files(1).folder, 'data', 'analytics'));

    % Update files and directories lists
    files = dir;
end

directories = files([files.isdir]); % Get folders
directories(strmatch('.',{files([files.isdir]).name})) = []; % remove hidden

% Generate path names for all subfolders
paths = arrayfun(@(x)fullfile(directories(x).folder,directories(x).name),1:length(directories),'UniformOutput',false);

% Add folders to matlab path
for j = 1:length(paths)
    addpath(genpath(paths{j}))
end

end
%-------------------------------------------------------------------------------
% load('processedData.mat');
%-------------------------------------------------------------------------------
% fprintf(1,'Adding path to MatlabmySQL toolbox\n');
% addpath('/Users/benfulcher/DropboxSydneyUni/CodeToolboxes/MatlabmySQL/')
