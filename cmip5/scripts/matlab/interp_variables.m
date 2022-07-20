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
age_filename = fullfile(exp_raw_path, 'cmip5', 'lgm', 'cmip5_sic_lgm_raw_data_monthly.nc'); 

%   get variables names ::
group_names = ncread(age_filename, 'group_names');
variable_names = ncread(age_filename, 'variable_names');

%   get number of models ::
NUMMOD = size(group_names, 1);

%%  interpolate each model
%   loop through each model ::
for iMod = 1 : 1 : NUMMOD

    %   get data ::
    mod_data = ncread(age_filename, [group_names{iMod} variable_names{iMod}]);
    mod_lon = ncread(age_filename, [group_names{iMod} 'lon']);
    mod_lat = ncread(age_filename, [group_names{iMod} 'lat']);

    %   run interpolation ::
    


end


%%  end program