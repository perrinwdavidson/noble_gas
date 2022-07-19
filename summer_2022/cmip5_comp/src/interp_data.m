function cmip_data_uvic = interp_data(cmip_data, variable, products, age)
%--------------------------------------------------------------------------
%   purpose: interpolating cmip5 data to uvic data
%   author: perrin w. davidson
%   contact: perrinwdavidson@gmail.com
%   date: 06.07.22
%--------------------------------------------------------------------------
%%  let me know what is going on
if strcmp(variable, 'sic')

    disp(['Interpolating ' variable ' to UVic grid.']); 
    
elseif strcmp(variable, 'ua') || strcmp(variable, 'va')

    disp(['Interpolating ' variable 'to CORE-2 grid.']); 

end

%%   add paths
addpath('/Users/perrindavidson/Documents/MATLAB/toolboxes/interpolation/min_curve/');
addpath('/Users/perrindavidson/Documents/MATLAB/toolboxes/plotting/m_map/');

%%  load data
%   uvic data
if strcmp(variable, 'sic')
        
    load(fullfile('io', 'inputs', 'uvic', 'grid'), 'x', 'y', 'nx', 'ny', 'ideep');
    ideep(ideep ~= 0) = 1; 
    ind_lm = find(ideep(:) == 1);
    land_mask = logical(ideep(:));
    clear('ideep');

elseif strcmp(variable, 'ua') || strcmp(variable, 'va')

    x = ncread(fullfile('io', 'inputs', 'core2', 'u_10.15JUNE2009.nc'), 'LON');
    y = ncread(fullfile('io', 'inputs', 'core2', 'u_10.15JUNE2009.nc'), 'LAT');
    nx = length(x); 
    ny = length(y);

end

%%  make grids
%   set dimensions ::
NUMMOD = length(cmip_data); 
NUMMON = 12;

%   make uvic grid ::
[lat, lon] = meshgrid(y, x);  
if strcmp(variable, 'sic')
    
    %   mask data ::
    lon_vec = lon(land_mask);  
    lat_vec = lat(land_mask);

end
        
%%  preallocate arrays
cmip_data_uvic_mod = cell(size(cmip_data));
cmip_data_uvic = cell([1, NUMMON]);

%%  loop through all models
%   interpolate ::
for iMod = 1 : 1 : NUMMOD

    %   get sic model data ::
    model_data = cmip_data{1, iMod}.value;
    model_lon = cmip_data{1, iMod}.lon;  % full grids to be indexed over
    model_lat = cmip_data{1, iMod}.lat;

    %   average data ::
    disp('Calculating monthly mean climatology.')
    model_data_mm = NaN(NUMX, NUMY, NUMMON);
    for iMonth = 1 : 1 : 12

        %   calculate mean ::
        model_data_mm(:, :, iMonth) = mean(model_data(:, :, iMonth : 12 : end), 3, 'omitnan');

    end
    model_data = model_data_mm;

    %   make meshgrid if only a vector ::
    if (sum(size(model_lon) == 1) > 0) || (sum(size(model_lat) == 1) > 0)

        %   meshgrid ::
        [model_lat, model_lon] = meshgrid(model_lat, model_lon);

    end

    %   make sure that we are only using [0, 360] for longitude ::
    if sum(size(model_lon) < 0) > 0

        %   correct ::
        model_lon(model_lon < 0) = model_lon(model_lon < 0) + 360;

    end

    %   make sure that we are only using [0 1] scale ::
    if sum(size(model_data) > 1) > 0 && strcmp('sic', variable)

        %   correct ::
        model_data = model_data / 100;  % assume that it is out of 100
        model_data(model_data < 0) = 0;  % remove negative values

    end

    %   write out interpolation ::
    disp(['Starting Minimum Curvature Interpolation for ' products{iMod, 1}]);

    %   start plot ::        
    close;
    t = tiledlayout(3, 4, 'tileSpacing', 'compact');

    %   interpolate through all months ::
    for iMon = 1 : 1 : NUMMON

        %   vectorize data ::
        model_lon_vec = double(model_lon(:)); 
        model_lat_vec = double(model_lat(:));
        data_vec = model_data(:, :, iMon);
        data_vec = data_vec(:); 
        data = rmmissing([model_lon_vec, model_lat_vec, data_vec]);

        %   average duplicate values ::
        [unique_coords, ~, idx] = unique(data(:, 1 : 2), 'rows', 'stable');
        unique_values = accumarray(idx, data(:, 3), [], @mean); 
        data = [unique_coords, unique_values];

        %   interpolate :: 
        [~, ~, data_interp] = mincurvi(data(:, 1), data(:, 2), data(:, 3), lon_vec, lat_vec); 
        if strcmp(variable, 'sic')

            data_noMask = NaN(size(land_mask));
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

        %   plot ::
        %-  get colorbar limits ::
        if strcmp(variable, 'sic')

            color_limits = 0 : 0.1 : 1; 
            color_map = bone(10); 

        elseif strcmp(variable, 'ua') || strcmp(variable, 'va')

            color_limits = linspace(min(shaped_interp, [], 'all'), max(shaped_interp, [], 'all'), 10);
            color_map = summer(10); 

        end

        %-  plot contourf ::
        nexttile();
        m_proj('miller', 'lon', [0 360], 'lat', [min(y) max(y)]);
        m_contourf(lon, lat, shaped_interp, color_limits, 'edgecolor', 'none');
        m_coast('patch', [.8 .8 .8]);
        m_grid('box', 'fancy', 'tickdir', 'in');
        colormap(color_map);
        colorbar('eastOutside');
        title(['Month ' num2str(iMon)]);

        %   store ::
        cmip_data_uvic_mod{1, iMod}(:, :, iMon) = shaped_interp;

        %   write out how we are doing ::
	    disp(['Done with interpolation for month ' num2str(iMon)]);

    end

    %   title plot ::
    if strcmp(variable, 'sic')

        title(t, [products{iMod} ' Sea Ice Fraction'], 'fontWeight', 'bold')

    elseif strcmp(variable, 'ua')
    
        title(t, [products{iMod} ' U10'], 'fontWeight', 'bold')

    elseif strcmp(variable, 'va')

        title(t, [products{iMod} ' V10'], 'fontWeight', 'bold')

    end

    %   set and save plot ::
    set(gcf, 'position', [0, 0, 1920, 1000]); 
    exportgraphics(t, fullfile('io', 'outputs', 'plots', variable, age, [variable '_' age '_' products{iMod} '.png']), 'resolution', 300); 

    %   write out how we are doing ::
	disp(['Done with interpolation for ' products{iMod, 1}]);

end

%%  put into monthly arrays
%   loop over all months and models ::
for iMon = 1 : 1 : NUMMON

  for iMod = 1 : 1 : NUMMOD

    %  store data ::
    cmip_data_uvic{1, iMon}(:, :, iMod) = cmip_data_uvic_mod{1, iMod}(:, :, iMon);

  end

end

%--------------------------------------------------------------------------
end