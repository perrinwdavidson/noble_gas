function [lon, lat, cmip_data_interp, variable_old, age, products] = interp_cmip5_variable(filename, products, interp_type, extrap_type)
%--------------------------------------------------------------------------
%   purpose: interpolating cmip5 data to uvic or core-2 grids
%   author: perrin w. davidson
%   contact: perrinwdavidson@gmail.com
%   date: 06.07.22
%--------------------------------------------------------------------------
%%  configure
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

%   let me know what is going on ::
if strcmp(variable, 'sic')

    disp(append('Interpolating ', upper(variable), ' to UVic grid.')); 
    
elseif strcmp(variable, 'ua') || strcmp(variable, 'va')

    disp(append('Interpolating ', upper(variable), ' to CORE-2 grid.')); 

end

%%  load data
%   uvic data ::
if strcmp(variable, 'sic')
        
    %   grid data ::
    load(fullfile('data', 'exp_raw', 'uvic', 'grid'), 'x', 'y', 'nx', 'ny', 'ideep');
    [uvic_lat, uvic_lon] = meshgrid(y, x);  

    %   ice faction ::
    load(fullfile('data', 'exp_raw', 'uvic', age, 'ice_fraction'), 'Fice');

    %   make land mask ::
    ideep(ideep ~= 0) = 1; 
    ind_lm = find(ideep(:) == 1);
    land_mask = logical(ideep(:));
    clear('ideep');

%   core grid  (we do not mask core) ::
elseif strcmp(variable, 'ua') || strcmp(variable, 'va')

    %   uvic ::
    load(fullfile('data', 'exp_raw', 'uvic', 'grid'), 'x', 'y', 'ideep');
    load(fullfile('data', 'exp_raw', 'uvic', age, 'wind_speed'), 'windspeed');
    [uvic_lat, uvic_lon] = meshgrid(y, x);  

    %   core grid ::
    x = ncread(fullfile('data', 'exp_raw', 'core2', 'u_10.15JUNE2009.nc'), 'LON');
    y = ncread(fullfile('data', 'exp_raw', 'core2', 'u_10.15JUNE2009.nc'), 'LAT');
    [core_lat, core_lon] = meshgrid(y, x);  
    nx = length(x); 
    ny = length(y);

end

%%  get inputs for this model
%   get variables names ::
group_names = ncread(filename, 'group_names');
variable_names = ncread(filename, 'variable_names');

%   get land mask filename ::
if strcmp(age, 'lgm')

    mask_filename = 'land_mask_lgm.nc';

elseif strcmp(age, 'pic')

    mask_filename = 'land_mask_pic.nc';

end

%   get land mask variables names ::
group_names_mask = ncread(mask_filename, 'group_names');
variable_names_mask = ncread(mask_filename, 'variable_names');

%   get number of models ::
NUMMOD = size(group_names, 1);

%   set number of months ::
NUMMON = 12;

%%  make grids
%   make grid ::
[lat, lon] = meshgrid(y, x);  
if strcmp(variable, 'sic')
    
    %   mask data ::
    lon_vec = lon(land_mask);  
    lat_vec = lat(land_mask);

elseif strcmp(variable, 'ua') || strcmp(variable, 'va')

    lon_vec = lon(:); 
    lat_vec = lat(:);

end
        
%%  preallocate arrays
cmip_data_interp = cell([1, NUMMOD]); 

%%  loop through all models
%   interpolate ::
for iMod = 1 : 1 : NUMMOD

    %   for cmip5 ::
    if iMod < 8

        %   get model data ::
        model_data = ncread(filename, append(group_names{iMod}, variable_names{iMod}));
        model_lon = ncread(filename, append(group_names{iMod}, 'lon'));
        model_lat = ncread(filename, append(group_names{iMod}, 'lat'));
        model_mask = ncread(mask_filename, append(group_names_mask{iMod}, variable_names_mask{iMod}));

        %   vectorize coordinates ::
        data_vec_mask = model_mask(:); 
        model_lon_vec = double(model_lon(:)); 
        model_lat_vec = double(model_lat(:)); 

    %   for uvic ::
    elseif iMod == 8

        %   if sic ::
        if strcmp(variable, 'sic')

            %   get model data ::
            model_data = Fice;
            model_lon = uvic_lon; 
            model_lat = uvic_lat;

        %   if windspeed ::
        elseif strcmp(variable, 'ua') || strcmp(variable, 'va')

            %   get model data ::
            model_data = windspeed;
            model_lon = uvic_lon;
            model_lat = uvic_lat;

        end

        %   vectorize coordinates ::
        model_lon_vec = double(model_lon(:)); 
        model_lat_vec = double(model_lat(:)); 

    end

    %   average data ::
    if iMod < 8 

        disp('Calculating monthly mean climatology.');
        model_data_mm = NaN(size(model_data, 1), size(model_data, 2), NUMMON);
        for iMonth = 1 : 1 : NUMMON

            %   calculate mean ::
            model_data_mm(:, :, iMonth) = mean(model_data(:, :, iMonth : 12 : end), 3, 'omitnan');

        end
        model_data = model_data_mm;

    end

    %   write out interpolation ::
    disp(append('Starting (', interp_type, ', ', extrap_type, ') Interpolation for ', variable_names{iMod}));

    %   interpolate through all months ::
    for iMon = 1 : 1 : NUMMON

        %   vectorize data ::
        data_vec = model_data(:, :, iMon);
        data_vec = data_vec(:); 

        %   quality control ::
        %-  make sure that we are only using [0 1] scale ::
        if sum(data_vec > 1, 'all') > 0 && strcmp('sic', variable)

            %   correct ::
            data_vec = data_vec ./ 100;  % assume that it is out of 100

        end

        %-  make sure we only are using positive values in range ::
        if strcmp('sic', variable)

            data_vec(data_vec < 0) = 0;  
            data_vec(data_vec > 1) = 1; 

        end

        %-  make sure that we are only using [0, 360] for longitude ::
        if sum(model_lon_vec < 0, 'all') > 0

            %   correct ::
            model_lon_vec(model_lon_vec < 0) = model_lon_vec(model_lon_vec < 0) + 360;

        end

        %   mask data ::
        data_vec(~data_vec_mask) = NaN;

        %   make data array ::
        data = rmmissing([model_lon_vec, model_lat_vec, data_vec]);

        %-  average duplicate values ::
        [unique_coords, ~, idx] = unique(data(:, 1 : 2), 'rows', 'stable');
        unique_values = accumarray(idx, data(:, 3), [], @mean); 
        data = [unique_coords, unique_values];

        %-  remove any 0 values from sic ::
        if strcmp('sic', variable)

            data = data(unique_values ~= 0, :);
            
        end

        %   interpolate :: 
        if strcmp(variable, 'sic')

            %   interpolate ::
            Finterp = scatteredInterpolant(data(:, 1), data(:, 2), log(data(:, 3)), interp_type, extrap_type); 
            data_interp = Finterp(lon_vec, lat_vec); 

            %   return by removing log ::
            data_interp = exp(data_interp);

        elseif strcmp(variable, 'ua') || strcmp(variable, 'va')

            Finterp = scatteredInterpolant(data(:, 1), data(:, 2), data(:, 3), interp_type, extrap_type); 
            data_interp = Finterp(lon_vec, lat_vec); 

        end
 
        %   put back into grid if sic ::
        if strcmp(variable, 'sic')

            data_noMask = zeros(size(land_mask));
            data_noMask(ind_lm) = data_interp;
            data_interp = data_noMask;

        end

        %   reshape ::
        shaped_interp = reshape(data_interp, [nx, ny]);

        %   exclude out of range values for sic ::
        if strcmp('sic', variable)

            shaped_interp(shaped_interp < 0) = 0;
            shaped_interp(shaped_interp > 1) = 1;

        end

        %   replace if sic, as interpolation to same locations gives skewed results ::
        if strcmp(variable, 'sic') && (iMod == 8)

            shaped_interp = Fice(:, :, iMon); 

        end

        %   store ::
        cmip_data_interp{1, iMod}(:, :, iMon) = shaped_interp;

        %   write out how we are doing ::
	    disp(append('Done with interpolation for month ', num2str(iMon)));

    end

    %   write out how we are doing ::
	disp(append('Done with interpolation for ', variable_names{iMod, 1}));

end

%--------------------------------------------------------------------------
end