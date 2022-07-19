%%  make_forcings
%%-------------------------------------------------------------------------
%   purpose: compile forcings to be read into tmm/inertgasgasex_l13_xatm
%   author: perrin w. davidson
%   contact: perrinwdavidson@gmail.com
%   date: 15.07.22
%%-------------------------------------------------------------------------
%%  load data
%   grid data ::
load(fullfile(input_path, 'uvic', 'grid.mat'), 'x', 'y', 'nx', 'ny', 'ideep');  % x and y correspond to (x, y) or (lon, lat)
t = [-45 -15 15 46 74 105 135 166 196 227 258 288 319 349 380 410]';  % from exports3D (siegel et al. 2014). center of each month by day from November to February

%   core2 ::
core_x = ncread(fullfile(input_path, 'core2', 'u_10.15JUNE2009.nc'), 'LON');  % x and y correspond to (x, y) or (lon, lat)
core_nx = length(core_x); 
core_y = ncread(fullfile(input_path, 'core2', 'u_10.15JUNE2009.nc'), 'LAT'); 
core_ny = length(core_y);
core_t = ncread(fullfile(input_path, 'core2', 'u_10.15JUNE2009.nc'), 'TIME'); 
core_nt = length(core_t);

%   uvic default ::
load(fullfile(input_path, 'uvic', 'pic', 'wind_speed.mat'), 'windspeed');
uvic_wind.pic = windspeed; 
load(fullfile(input_path, 'uvic', 'lgm', 'wind_speed.mat'), 'windspeed');
uvic_wind.lgm = windspeed; 
clear('windspeed')

%   make sea mask ::
sea_mask = ideep; 
sea_mask(sea_mask ~= 0) = 1; 

%%  collect by models and interpolate 
%   set dimensions ::
NUMMON = size(cmip5_sic_pic_uvic_monthly, 2);
NUMMOD = size(cmip5_sic_pic_uvic_monthly{1, 1}, 3);

%   preallocate ::
pic_sic = cell([1, NUMMOD]);
lgm_sic = cell([1, NUMMOD]);
pic_u10 = cell([1, NUMMOD]);
lgm_u10 = cell([1, NUMMOD]);
pic_v10 = cell([1, NUMMOD]);
lgm_v10 = cell([1, NUMMOD]);

%   collect data in array ::  % do step-wise interpolate (monthly factor)
for iMon = 1 : 1 : NUMMON

    for iMod = 1 : 1 : NUMMOD

        %   sic ::
        %-  get data ::
        pic_sic_data = cmip5_sic_pic_uvic_monthly{1, iMon}(:, :, iMod);
        lgm_sic_data = cmip5_sic_lgm_uvic_monthly{1, iMon}(:, :, iMod);

        %-  sea mask data ::
        pic_sic_data(~sea_mask) = 0; 
        lgm_sic_data(~sea_mask) = 0; 

        %- store data ::
        pic_sic{1, iMod}(:, :, iMon) = pic_sic_data;
        lgm_sic{1, iMod}(:, :, iMon) = lgm_sic_data;

        %   u10 ::
        pic_u10{1, iMod}(:, :, iMon) = cmip5_u10_pic_uvic_monthly{1, iMon}(:, :, iMod);
        lgm_u10{1, iMod}(:, :, iMon) = cmip5_u10_lgm_uvic_monthly{1, iMon}(:, :, iMod);

        %   v10 ::
        pic_v10{1, iMod}(:, :, iMon) = cmip5_v10_pic_uvic_monthly{1, iMon}(:, :, iMod);
        lgm_v10{1, iMod}(:, :, iMon) = cmip5_v10_lgm_uvic_monthly{1, iMon}(:, :, iMod);

    end

end

%%  interpolate 
%   make grid vectors ::
[lat, lon, time] = meshgrid(y, x, t);
[core_lat, core_lon, core_time] = meshgrid(core_y, core_x, core_t);

%   loop through all models ::
for iMod = 1 : 1 : NUMMOD

    %   u10 ::
    pic_u10{1, iMod} = concat_interp(lat, lon, time, pic_u10{1, iMod}, core_lat, core_lon, core_time);
    lgm_u10{1, iMod} = concat_interp(lat, lon, time, lgm_u10{1, iMod}, core_lat, core_lon, core_time);

    %   v10 ::
    pic_v10{1, iMod} = concat_interp(lat, lon, time, pic_v10{1, iMod}, core_lat, core_lon, core_time);
    lgm_v10{1, iMod} = concat_interp(lat, lon, time, lgm_v10{1, iMod}, core_lat, core_lon, core_time);

end

%   interpolate uvic ::
wind_uvic{1} = concat_interp(lat, lon, time, uvic_wind.pic, core_lat, core_lon, core_time);
wind_uvic{2} = concat_interp(lat, lon, time, uvic_wind.lgm, core_lat, core_lon, core_time);

%%  make final arrays
%   sic ::
sea_ice_cmip5{1} = pic_sic; 
sea_ice_cmip5{2} = lgm_sic; 

%   u10 ::
u10_cmip5{1} = pic_u10; 
u10_cmip5{2} = lgm_u10; 

%   v10 ::
v10_cmip5{1} = pic_v10; 
v10_cmip5{2} = lgm_v10; 

%%	save data
save(fullfile(output_path, 'cmip5', 'sea_ice_cmip5.mat'), 'sea_ice_cmip5');
save(fullfile(output_path, 'uvic', 'wind_uvic.mat'), 'wind_uvic');
save(fullfile(output_path, 'cmip5', 'u10_cmip5.mat'), 'u10_cmip5', '-v7.3');
save(fullfile(output_path, 'cmip5', 'v10_cmip5.mat'), 'v10_cmip5', '-v7.3');

%%  end program