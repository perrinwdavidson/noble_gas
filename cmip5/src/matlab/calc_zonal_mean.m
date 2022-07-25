function [core_lat_interp, zonal_mean] = calc_zonal_mean(filename, interp_type_zonal_mean, extrap_type_zonal_mean)
%--------------------------------------------------------------------------
%   purpose: calculating zonal mean windspeed for cmip5 data at core-2 grid
%   author: perrin w. davidson
%   contact: perrinwdavidson@gmail.com
%   date: 06.07.22
%--------------------------------------------------------------------------
%%  configure
%   let me know what is going on ::
disp("Calculating zonal mean windspeed.");

%   get variable name ::
variable = filename(7 : 9);
variable_old = variable; 
if strcmp(variable, 'u10')  % rename to cmip5

    variable = 'ua'; 

elseif strcmp(variable, 'v10')  % rename to cmip5

    variable = 'va';

end

%   get age ::
age = filename(11 : 13);

%%  load data
%   uvic data ::
%-  raw data :: 
load(fullfile('data', 'exp_raw', 'uvic', age, 'wind_speed'), 'windspeed');
load(fullfile('data', 'exp_raw', 'uvic', 'grid'), 'x', 'nx', 'y', 'ny', 'ideep');
[uvic_lat, ~] = meshgrid(y, x); 

%-  make land mask ::
ideep(ideep ~= 0) = 1; 
uvic_land_mask = logical(ideep);
uvic_land_mask_vec = mean(uvic_land_mask, 1, 'omitnan')'; 
uvic_lat_extent = y(uvic_land_mask_vec ~= 0); 

%   core data ::
%-  get data ::
core_lat = ncread(fullfile('data', 'exp_raw', 'core2', 'u_10.15JUNE2009.nc'), 'LAT');

%-  only use data that is not extrapolated to by uvic standards ::
core_lat_interp = core_lat(core_lat <= max(uvic_lat_extent) & core_lat >= min(uvic_lat_extent));

%   get land mask filename ::
if strcmp(age, 'lgm')

    mask_filename = 'land_mask_lgm.nc';

elseif strcmp(age, 'pic')

    mask_filename = 'land_mask_pic.nc';

end

%%  set and get important values
%   get variables names ::
group_names = ncread(filename, 'group_names');
variable_names = ncread(filename, 'variable_names');

%   get land mask variables names ::
group_names_mask = ncread(mask_filename, 'group_names');
variable_names_mask = ncread(mask_filename, 'variable_names');

%   append uvic ::
group_names = [group_names; {append('UVic ', upper(age), ' Default')}];
variable_names = [variable_names; {append('UVic Default ', upper(age), ' ' , upper(variable))}];

%   get number of models ::
NUMMOD = size(group_names, 1);  

%   set number of months ::
NUMMON = 12;

%%  preallocate
zonal_mean = cell(1, NUMMOD);

%%  calculate average
%   loop through all models ::
for iMod = 1 : 1 : NUMMOD

    %   for cmip5 ::
    if iMod < 8

        %   get model data ::
        model_data = ncread(filename, append(group_names{iMod}, variable_names{iMod}));
        model_lat = ncread(filename, append(group_names{iMod}, 'lat'));
        model_mask = logical(ncread(mask_filename, append(group_names_mask{iMod}, variable_names_mask{iMod})));

    %   for uvic ::
    elseif iMod == 8

        %   get model data ::
        model_data = windspeed;
        model_lat = uvic_lat;
        model_mask = uvic_land_mask;

    end

    %   loop through all months ::
    for iMonth = 1 : 1 : NUMMON

        %   get monthly data ::
        data_mon = model_data(:, :, iMonth); 

        %   mask data ::
        data_mon(~model_mask) = NaN;

        %   calculate average ::
        %-  remove masked values ::
        data_vec = rmmissing([model_lat(:), data_mon(:)]);

        %-  average along latitude ::
        [unique_coords, ~, idx] = unique(data_vec(:, 1), 'rows', 'stable');
        unique_values = accumarray(idx, data_vec(:, 2), [], @mean); 
        data_vec = [unique_coords, unique_values];

        %   interpolate data ::
        zonal_mean{iMod}(:, iMonth) = interp1(data_vec(:, 1), data_vec(:, 2), core_lat_interp, interp_type_zonal_mean, extrap_type_zonal_mean);

    end

    %   write out how we are doing ::
	disp(append('Done with interpolation for ', variable_names{iMod, 1}));

end

%--------------------------------------------------------------------------
end