%% Initialization
% Clear the screen for kicks
clc
% Clear the memory
clear all

% Set up the inputs
procYear = 2015;
procMonth = 12;
procDay = 04;

mesoFlag = true;
iMetFlag = true;
windsondFlag = true;

%% Local adjustments
% *** You will need to change the baseDir for your computer
% This is where your 'thermo' folder lives
baseDir = '/users/chilson/Matlab/CLOUDMAP/';

% Create the directory of the matlab library and add it to the path
libDir = [ baseDir filesep 'thermo' filesep 'matlab' filesep ]; 
addpath(libDir)

%% Mesonet data
if mesoFlag
    procStation = 'wash';
    % set fetchFlag to 1 if mesonet data should be retrieved automatically (mac only)
    % set fetchFlag to 0 if the files has alredy been download
    fetchFlag = 1;
    
    [matFileName, matDataDir, status] = mts2mat(procYear, procMonth, procDay, ...
        procStation, fetchFlag, baseDir);
end

%% iMet data
if iMetFlag
    [matFileName, dataDir, status] = iMet2mat(procYear, ...
        procMonth, procDay, baseDir);
end

%% Windsond data
if windsondFlag
    [matFileName, dataDir, status] = windsond2mat(procYear, ...
        procMonth, procDay, baseDir);
end

%% Clean up
% Remove the matlab library
rmpath(libDir)