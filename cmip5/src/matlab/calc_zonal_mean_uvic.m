function [core_lat, core_zonal_mean] = calc_zonal_mean_uvic(age)
%--------------------------------------------------------------------------
%   purpose: calculating zonal mean windspeed for uvic data at core-2 grid
%   author: perrin w. davidson
%   contact: perrinwdavidson@gmail.com
%   date: 20.07.22
%--------------------------------------------------------------------------
%%  configure
%   let me know what is going on ::
disp('Calculating zonal mean UVic windspeed.');

%%  load data
%   uvic ::
load(fullfile('data', 'exp_raw', 'uvic', 'grid'), 'y');
load(fullfile('data', 'exp_raw', 'uvic', age, 'wind_speed'), 'windspeed');
zonal_lat = y;

%   core ::
core_lat = ncread(fullfile('data', 'exp_raw', 'core2', 'u_10.15JUNE2009.nc'), 'LAT');

%%  quality control
%   remove 0s ::
windspeed(windspeed == 0) = NaN;

%%  calculate average
zonal_mean = squeeze(mean(windspeed, 1, 'omitnan')); 

%%  interpolate 
%   get length of months ::
NUMMON = size(zonal_mean, 2); 

%   preallocate array ::
core_zonal_mean = NaN(length(core_lat), NUMMON);

%   loop through all months ::
for iMon = 1 : 1 : NUMMON

    %   get data ::
    mon_data = zonal_mean(:, iMon); 

    %   make single data array ::
    mon_data = rmmissing([zonal_lat, mon_data]);

    %   interpolate ::
    core_zonal_mean(:, iMon) = interp1(mon_data(:, 1), mon_data(:, 2), core_lat, 'linear', 'extrap');

end

%--------------------------------------------------------------------------
end