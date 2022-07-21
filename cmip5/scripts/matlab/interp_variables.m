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

%%  interpolate and save
%   loop through all files ::
for iFile = filenames

    %   interpolate the file ::
    [interp_lon, interp_lat, cmip_data_interp, variable, age] = interp_cmip5_variable(iFile);

    %   calculate zonal wind ::
    if strcmp(variable, 'u10') || strcmp(variable, 'v10')

        zonal_mean = calc_zonal_mean(interp_lat, cmip_data_interp); 

    end

    %   write data ::
    %-  interpolated variable ::
    write_cmip5_interp_variable(interp_lon, interp_lat, cmip_data_interp, variable, products, age, fullfile(exp_pro_path, "cmip5", age, strcat("cmip5_", variable, "_", age, "_interp_monthly.nc")));

    %-  zonal mean windspeed ::
    if strcmp(variable, 'u10') || strcmp(variable, 'v10')

        write_cmip5_zonal_windspeed(zonal_mean, variable, products, age, fullfile(exp_pro_path, "cmip5", age, strcat("cmip5_", variable, "_", age, "_zonal_mean_monthly.nc")));

    end
    
end

%%  end program