function cmip_data_uvic = interp_data(cmip_data, uvic_grid_path, variable, products)
%--------------------------------------------------------------------------
%   purpose: interpolating cmip5 data to uvic data
%   author: perrin w. davidson
%   contact: perrinwdavidson@gmail.com
%   date: 06.07.22
%--------------------------------------------------------------------------
%%  let me know what is going on
disp('Interpolating to UVic grid from: '); 

%%  load data
load(uvic_grid_path, 'x', 'y', 'nx', 'ny');

%%  make uvic grids
%   set dimensions ::
NUMMOD = length(cmip_data); 
NUMMON = 12;

%   make grid ::
[uvic_lat, uvic_lon] = meshgrid(y, x);  
uvic_lon_vec = uvic_lon(:);  
uvic_lat_vec = uvic_lat(:);
        
%%  preallocate arrays
cmip_data_uvic_mod = cell(size(cmip_data));
cmip_data_uvic = cell([1, NUMMON]);

%%  loop through all models
%   interpolate ::
for iMod = 1 : 1 : NUMMOD

    %  get sic model data ::
    model_data = cmip_data{1, iMod}.value;
    model_lon = cmip_data{1, iMod}.lon;  % full grids to be indexed over
    model_lat = cmip_data{1, iMod}.lat;

    %  make meshgrid if only a vector ::
    if (sum(size(model_lon) == 1) > 0) || (sum(size(model_lat) == 1) > 0)

        %  meshgrid ::
        [model_lat, model_lon] = meshgrid(model_lat, model_lon);

    end

    %  make sure that we are only using [0, 360] for longitude ::
    if sum(size(model_lon) < 0) > 0

        %  correct ::
        model_lon(model_lon < 0) = model_lon(model_lon < 0) + 360;

    end

    %  make sure that we are only using [0 1] scale ::
    if sum(size(model_data) > 1) > 0 && strcmp('sic', variable)

        %  correct ::
        model_data = model_data / 100;  % assume that it is out of 100

    end

    %  interpolate through all months ::
    for iMon = 1 : 1 : NUMMON

        %  vectorize data ::
        lon_vec = double(model_lon(:)); 
        lat_vec = double(model_lat(:));
        data_vec = model_data(:, :, iMon);
        data_vec = data_vec(:); 
        data = rmmissing([lon_vec, lat_vec, data_vec]); 

        %  interpolate ::
        warning('off', 'all')  % there is duplicated data given the projection of some products
        Finterp = scatteredInterpolant(data(:, 1), data(:, 2), data(:, 3), 'linear');
        data_interp = Finterp(uvic_lon_vec, uvic_lat_vec);
        warning('on', 'all')

        %  reshape ::
        shaped_interp = reshape(data_interp, [nx, ny]);

        %   exclude out of range values ::
        shaped_interp(shaped_interp < 0) = 0;
        shaped_interp(shaped_interp > 1) = 1;

        %   store ::
        cmip_data_uvic_mod{1, iMod}(:, :, iMon) = shaped_interp;

    end
    
    %   write out how we are doing ::
	disp(products{iMod, 1});

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