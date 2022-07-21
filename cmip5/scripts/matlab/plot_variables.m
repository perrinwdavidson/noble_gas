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
             'v10_pic_zonal_mean_interp_monthly.nc', ...
             'u10_lgm_interp_monthly.nc', ...
             'u10_pic_interp_monthly.nc', ...
             'v10_lgm_interp_monthly.nc', ...
             'v10_pic_interp_monthly.nc'};  % preserve ordering of {lgm, pic}

%%  plot
%   set initial value ::
iFile = 1; 

%   loop through all files ::
while iFile < size(filenames, 2)

    %   get filename ::
    filename1 = filenames{iFile};

    %   get variable ::
    variable = filename1(1 : 3);

    %   plot wind ::
    if strcmp(variable, 'u10') || strcmp(variable, 'v10')

        %   get kind ::
        wind_kind = filename1(9 : 13);

        %   get age ::
        age = filename1(5 : 7);

        %   plot zonal mean ::
        if strcmp(wind_kind, 'zonal')

            %   get second filename ::
            filename2 = filenames{iFile + 1};

            %   plot ::
            plot_mean_wind(variable, filename1, filename2, products, age); 

            %   iterate ::
            iFile = iFile + 2; 

        %    plot geographic distribution ::
        else

            %   plot ::
            plot_wind(filename1, products, variable, age);

        end

    %   plot sea ice ::
    elseif strcmp(variable, 'sic')

        %   get age ::
        age = filename1(5 : 7);

        %   plot ::
        plot_ice(filename1, products, variable, age);

    end

    %   iterate ::
    iFile = iFile + 1; 
    
end

%%=========================================================================