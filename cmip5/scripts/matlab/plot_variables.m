%%=========================================================================
%   run_cmip5_comp
%%-------------------------------------------------------------------------
%   purpose: to plot cmip5 windspeed (u10, v10) and sea ice fraction (sic).
%   author: perrin w. davidson
%   contact: perrinwdavidson@gmail.com
%   date: 20.07.22
%%=========================================================================
%%  configure
%   set file names ::
filenames = {'cmip5_sic_lgm_interp_monthly.nc', ...
             'cmip5_sic_pic_interp_monthly.nc', ...
             'cmip5_u10_lgm_zonal_mean_monthly.nc', ...
             'cmip5_u10_pic_zonal_mean_monthly.nc', ...
             'uvic_windspeed_lgm_zonal_mean_monthly.nc', ...
             'cmip5_v10_lgm_zonal_mean_monthly.nc', ...
             'cmip5_v10_pic_zonal_mean_monthly.nc'};  % preserve ordering of {lgm, pic}

%%  plot
%   loop through all files ::
for iFile = 1 : 1 : size(filenames, 2)

    %   get filename ::
    filename1 = filenames{iFile};

    %   get variable ::
    variable = filename1(7 : 9);

    %   plot zonal mean wind ::
    if strcmp(variable, 'u10') || strcmp(variable, 'v10')

        %   get second filename ::
        filename2 = filenames{iFile + 1};

        %   plot ::
        plot_mean_wind(variable, filename1, filename2); 

        %   iterate ::
        iFile = iFile + 1; 

    %   plot sea ice ::
    elseif strcmp(variable, 'sic')

        %   plot ::
        plot_ice(filename1);

    end
    
end

%%=========================================================================