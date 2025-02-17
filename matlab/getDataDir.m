function dataDir = getDataDir(baseDir, procYear, procMonth, procDay, sensorType)
% Function used to create the path to data files based on date and sensor
% type
% baseDir is the local directory  where the folder 'thermo' lives

% Create the directory using the file separators appropriate for your OS
dataDir = sprintf('%sthermo%sdata%s%s%s%4.4d%s%2.2d%s%2.2d%s', ...
    baseDir, filesep, filesep, sensorType, filesep, ...
    procYear, filesep, procMonth, filesep, procDay, filesep);