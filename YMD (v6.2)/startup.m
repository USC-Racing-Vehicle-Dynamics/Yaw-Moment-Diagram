% setup.m in Yaw-Moment-Diagram

% Add this repo (Yaw-Moment-Diagram) to path
fullScriptPath = mfilename('fullpath');
currentFolder = fileparts(fullScriptPath);

% Get repo root (Yaw-Moment-Diagram)
repoRootPath = currentFolder;
while ~strcmpi(fileparts(repoRootPath), repoRootPath)
    [parentFolder, currentName] = fileparts(repoRootPath);
    if strcmpi(currentName, 'Yaw-Moment-Diagram')
        repoRootPath = fullfile(parentFolder, currentName);
        break;
    end
    repoRootPath = parentFolder;
end

addpath(genpath(repoRootPath));

% add readMatlabConfig.m
scrConfigPath = fullfile(parentFolder, 'scr_config');
readMatlabConfigFile = fullfile(scrConfigPath, 'readMatlabConfig.m');

if isfile(readMatlabConfigFile)
    addpath(scrConfigPath); % Only add the folder containing readMatlabConfig.m
    disp(['Added readMatlabConfig.m to path from: ', scrConfigPath]);
else
    warning('readMatlabConfig.m not found in scr_config folder.');
end

