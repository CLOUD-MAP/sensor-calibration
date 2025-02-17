function [mts, status] = readCSVMesonetData(procYear, procMonth, procDay, fileName, dirName)
% Function to read 1-minute Mesonet files
% Call: [mts, status] = readCSVMesonetData(procYear, procMonth, procDay, fileName, dirName)
% Inputs:
% procYear: year
% procMonth: month
% procDay: day
% fileName: name of the 1-min data file
% dirName: where the 1-min data file lives
% Outputs
% mts: structured array with variables
% status: status flag
% Units used for the variables are part of the name with the exception of
% time. Times are expressed in Matlab serial time format and are UTC
% Written by Phil Chilson (University of Oklahoma)

%% Error trapping
% =====================================================================
% Check number of input arguments and take appropriate actions
% =====================================================================
if nargin < 5
    fprintf('*** Error calling function ... exiting!\n')
    status = 0;
    return
end

% =====================================================================
% Check if the file exists and if so open it
% =====================================================================
if exist([ dirName fileName ], 'file')
  fprintf('Reading file: %s\n', [ dirName fileName ])
else
  fprintf('*** File not found!\n')
  mts = [];
  status = 0;
  return
end

%% Import the data
data = csvread([ dirName fileName ] ,0, 4);

dateAsNum = datenum(procYear, procMonth, procDay);

%% Assign values
% =====================================================================
% Read the data and assign them to the structured array
% =====================================================================
%mts.stationNumber(icnt) = STNM;
mts.obsTime = dateAsNum + (0: 1439)/1440; % 1440 min in a day
mts.humidity_perCent = data(:, 1);
mts.temperature1p5m_C = data(:, 2);
mts.solarRadiation_Wpm2 = data(:, 3);
mts.rain_mm = data(:, 4);
mts.rain2_mm = data(:, 5);
mts.pressure_Pa = 100*(data(:, 6) + 700);
mts.pressureMin_Pa = 100*(data(:, 7) + 700);
mts.pressureMax_Pa = 100*(data(:, 8) + 700);
mts.windSpeed10m_mps = data(:, 9);
mts.windDirection10m_deg = data(:, 10);
mts.temperature9m_C = data(:, 11);
mts.windSpeed2m_mps = data(:, 12);
mts.windSpeedMax10m_mps = data(:, 13);
mts.sodTemperature10cm_C = data(:, 14);
mts.battery_V = data(:, 15);
mts.batteryMin_V = data(:, 16);
mts.batteryMax_V = data(:, 17);

status = 1;