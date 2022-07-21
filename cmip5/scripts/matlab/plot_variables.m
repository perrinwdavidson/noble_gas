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
filenames = {'sic_lgm_interp_monthly.nc', ...
             'sic_pic_interp_monthly.nc', ...
             'u10_lgm_zonal_mean_interp_monthly.nc', ...
             'u10_pic_zonal_mean_interp_monthly.nc', ...
             'v10_lgm_zonal_mean_interp_monthly.nc', ...
             'v10_pic_zonal_mean_interp_monthly.nc'};  % preserve ordering of {lgm, pic}

%%  plot
%   loop through all files ::
while iFile < size(filenames, 2)

    %   get filename ::
    filename1 = filenames{iFile};

    %   get variable ::
    variable = filename1(1 : 3);

    %   plot zonal mean wind ::
    if strcmp(variable, 'u10') || strcmp(variable, 'v10')

        %   get second filename ::
        filename2 = filenames{iFile + 1};

        %   plot ::
        plot_mean_wind(variable, filename1, filename2, products); 

        %   iterate ::
        iFile = iFile + 2; 

    %   plot sea ice ::
    elseif strcmp(variable, 'sic')

        %   plot ::
        plot_ice(filename1, products);

    end

    %   iterate ::
    iFile = iFile + 1; 
    
end

%%=========================================================================