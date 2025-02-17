function [windsond, status] = readWindsond(dirName, fileName)
% =====================================================================
% readWindsond
% [windsond, status] = readWindsond(dirName, fileName)
% =====================================================================
% Read data in the windsond format
% Inputs:
% dirName  = directory where data file exists
% fileName = name of the windsond data file (*.sounding)
% Outputs
% windsond = structured array containing data
% status   = flag indiating status of read
% Created 2015-12-09 Phil Chilson
% Revision history

% =====================================================================
% Check if the file exists
% =====================================================================
if ~exist([ dirName fileName ], 'file')
    fprintf('*** readWindsond: file does not exist ... exiting!\n')
    windsond = [];
    status = 0;
    return
end

% =====================================================================
% Open the file for reading
% =====================================================================
fileID = fopen([ dirName fileName ], 'r');
fprintf('Reading file: %s\n', [ dirName fileName ])

% =====================================================================
% Read the header data
% =====================================================================
str = fgetl(fileID);
begTime = datenum(str(17:35), 'yyyy-mm-dd HH:MM:SS');
for j = 1: 6
    str = fgetl(fileID);
end
% This accounts for a change in the file format
if begTime < datenum(2016, 5, 15)
    dataStrID = 'DAT';
else
    dataStrID = 'MET';
end

% =====================================================================
% Read the data
% =====================================================================
iCount = 1;
while ~feof(fileID)
    str = fgetl(fileID);
    ind = strfind(str, dataStrID);
    if ~isempty(ind)
        str = strrep(str, ']', ','); % needed to help extract data
        % Time
        ind = strfind(str, ': ');
        timeStr = str(1: ind - 1);
        ind = strfind(timeStr, 'h');
        if isempty(ind)
            obsHour = 0;
        else
            obsHour = str2double(timeStr(1: ind - 1));
        end
        obsMinute = str2double(timeStr(end - 8: end - 7));
        obsSecond = str2double(timeStr(end - 5: end - 4)) + ...
            str2double(timeStr(end - 2: end))/1000;
        obsTime(iCount) = begTime + ...
            (60*obsHour + obsMinute + obsSecond/60)/60/24;
        % Battery charge
        valID = 'su';
        nChars = length(valID) + 1;
        ind1 = strfind(str, valID);
        if isempty(ind1)
            val = NaN;
        else
            ind2 = strfind(str(ind1:end), ',');
            val = str2double(str(ind1 + nChars: ind1 + ind2(1) - 2));
        end
        battery_V(iCount) = val;
        % Pressure
        valID = 'pa';
        nChars = length(valID) + 1;
        ind1 = strfind(str, valID);
        if isempty(ind1)
            val = NaN;
        else
            ind2 = strfind(str(ind1:end), ',');
            val = str2double(str(ind1 + nChars: ind1 + ind2(1) - 2));
        end
        pressure_Pa(iCount) = val;
        % Temperature
        valID = 'te';
        ind1 = strfind(str, valID);
        if isempty(ind1)
            val = NaN;
        else
            ind2 = strfind(str(ind1:end), ',');
            val = str2double(str(ind1 + nChars: ind1 + ind2(1) - 2));
        end
        temperature_C(iCount) = val;
        % Humidity
        valID = 'hu';
        ind1 = strfind(str, valID);
        if isempty(ind1)
            val = NaN;
        else
            ind2 = strfind(str(ind1:end), ',');
            val = str2double(str(ind1 + nChars: ind1 + ind2(1) - 2));
        end
        humidity_perCent(iCount) = val;
        % Internal temperature
        valID = 'te';
        ind1 = strfind(str, valID);
        if isempty(ind1)
            val = NaN;
        else
            ind2 = strfind(str(ind1:end), ',');
            val = str2double(str(ind1 + nChars: ind1 + ind2(1) - 2));
        end
        temperatureSensor_C(iCount) = val;
        % Latitude
        valID = 'lat';
        nChars = length(valID) + 1;
        ind1 = strfind(str, valID);
        if isempty(ind1)
            val = NaN;
        else
            ind2 = strfind(str(ind1:end), ',');
            val = str2double(str(ind1 + nChars: ind1 + ind2(1) - 2));
        end
        latitude_deg(iCount) = floor(val/1e6)+100*(val/1e6-floor(val/1e6))/60;
        % Longitude
        valID = 'lon';
        nChars = length(valID) + 1;
        ind1 = strfind(str, valID);
        if isempty(ind1)
            val = NaN;
        else
            ind2 = strfind(str(ind1:end), ',');
            val = str2double(str(ind1 + nChars: ind1 + ind2(1) - 2));
        end
        longitude_deg(iCount) = floor(val/1e6)+100*(val/1e6-floor(val/1e6))/60;
        % Altitude
        valID = 'alt';
        nChars = length(valID) + 1;
        ind1 = strfind(str, valID);
        if isempty(ind1)
            val = NaN;
        else
            ind2 = strfind(str(ind1:end), ',');
            val = str2double(str(ind1 + nChars: ind1 + ind2(1) - 2));
        end
        altitude_m(iCount) = val;
        % Speed
        valID = 'spd';
        nChars = length(valID) + 1;
        ind1 = strfind(str, valID);
        if isempty(ind1)
            val = NaN;
        else
            ind2 = strfind(str(ind1:end), ',');
            val = str2double(str(ind1 + nChars: ind1 + ind2(1) - 2));
        end
        speed_mps(iCount) = val;
        % Heading
        valID = 'ang';
        nChars = length(valID) + 1;
        ind1 = strfind(str, valID);
        if isempty(ind1)
            val = NaN;
        else
            ind2 = strfind(str(ind1:end), ',');
            val = str2double(str(ind1 + nChars: ind1 + ind2(1) - 2));
        end
        heading_deg(iCount) = val;
        % --
        iCount = iCount + 1;
    end
end

% =====================================================================
% Close the file
% =====================================================================
fclose(fileID);
% =====================================================================
% Create the structured array
% =====================================================================
windsond.obsTime = obsTime;
windsond.battery_V = battery_V;
windsond.pressure_Pa = pressure_Pa;
windsond.temperature_C = temperature_C;
windsond.humidity_perCent = humidity_perCent;
windsond.temperatureSensor_C = temperatureSensor_C;
windsond.latitude_deg = latitude_deg;
windsond.longitude_deg = longitude_deg;
windsond.altitude_m = altitude_m;
windsond.speed_mps = speed_mps;
windsond.heading_deg = heading_deg;

status = 1;