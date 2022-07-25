%%=========================================================================
%   interp_variables
%%-------------------------------------------------------------------------
%   purpose: to interpolate cmip5 data to core-2 and uvic grids
%   author: perrin w. davidson
%   contact: perrinwdavidson@gmail.com
%   date: 19.07.22
%%=========================================================================
%%  configure
%   set file names ::
filenames = {'cmip5_sic_lgm_raw_data_monthly.nc', ...
             'cmip5_sic_pic_raw_data_monthly.nc', ...
             'cmip5_u10_lgm_raw_data_monthly.nc', ...
             'cmip5_u10_pic_raw_data_monthly.nc', ...
             'cmip5_v10_lgm_raw_data_monthly.nc', ...
             'cmip5_v10_pic_raw_data_monthly.nc'}; 

%   set interpolation and extrapolation types ::
%-  general interpolation ::
interp_type = 'linear';  % linear, nearest, natural
extrap_type = 'nearest';  % linear, nearest

%-  zonal mean ::
interp_type_zonal_mean = 'makima';  % interpolation routine 
extrap_type_zonal_mean = 'extrap';  % specify whether or not we extrapolate

%%  interpolate and save
%   loop through all files ::
for iFile = filenames

    %%  interpolate
    %   get filename ::
    filename = iFile{:};

    %   interpolate the file ::
    [interp_lon, interp_lat, cmip_data_interp, variable, age] = interp_cmip5_variable(filename, interp_type, extrap_type); 

    %   calculate zonal wind ::
    if strcmp(variable, 'u10') || strcmp(variable, 'v10')

        %   calculate ::
        [interp_lat_zonal_mean, zonal_mean] = calc_zonal_mean(filename, interp_type_zonal_mean, extrap_type_zonal_mean);  % <- I am here, adding in mean calc (with nans over land mask) then interpolation

    end

    %%  write data
    %   all variables ::
    write_interp_variable(interp_lon, interp_lat, cmip_data_interp, variable, products, age, fullfile(exp_pro_path, age, strcat(variable, '_', age, '_interp_monthly.nc')));

    %   zonal wind ::
    if strcmp(variable, 'u10') || strcmp(variable, 'v10')

        %   write ::
        write_interp_zonal_mean_windspeed(interp_lat_zonal_mean, zonal_mean, variable, products, age, fullfile(exp_pro_path, age, strcat(variable, '_', age, '_zonal_mean_interp_monthly.nc')));

    end
    
end

%%  end program
%%=========================================================================
