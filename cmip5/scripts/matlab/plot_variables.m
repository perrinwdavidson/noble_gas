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
%-  global ::
filenames_global = {'sic_lgm_interp_monthly.nc', ...
                    'sic_pic_interp_monthly.nc', ...
                    'u10_lgm_interp_monthly.nc', ...
                    'u10_pic_interp_monthly.nc', ...
                    'v10_lgm_interp_monthly.nc', ...
                    'v10_pic_interp_monthly.nc'}; 

%-  zonal ::
filenames_zonal = {{'u10_lgm_zonal_mean_interp_monthly.nc', 'u10_pic_zonal_mean_interp_monthly.nc'}, ...
                   {'v10_lgm_zonal_mean_interp_monthly.nc', 'v10_pic_zonal_mean_interp_monthly.nc'}};

%%  plot global
%   loop through all files ::
for iFile = 1 : 1 : size(filenames_global, 2)

    %   get filename ::
    filename1 = filenames_global{iFile};

    %   get variable ::
    variable = filename1(1 : 3);

    %   plot wind ::
    if strcmp(variable, 'u10') || strcmp(variable, 'v10')

        %   get age ::
        age = filename1(5 : 7);

            %   plot ::
            plot_wind(filename1, products, variable, age);

    %   plot sea ice ::
    elseif strcmp(variable, 'sic')

        %   get age ::
        age = filename1(5 : 7);

        %   plot ::
        plot_ice(filename1, products, variable, age);

    end
    
end

%%  plot zonal mean
%   loop through all files ::
for iFile = 1 : 1 : size(filenames_zonal, 2)

    %   get filename ::
    filename1 = filenames_zonal{iFile}{1};
    filename2 = filenames_zonal{iFile}{2};

    %   get variable ::
    variable = filename1(1 : 3);

    %   get age ::
    age = filename1(5 : 7);

    %   plot ::
    plot_mean_wind(variable, filename1, filename2, products, age); 

end

%%=========================================================================