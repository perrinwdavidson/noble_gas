%%  compare_u10 -- compiling and calculating stats for cmip5 u10
%%-------------------------------------------------------------------------
%   purpose: to calculate cmip5 geographic distributions of windspeed (u10)
%   author: perrin w. davidson
%   contact: perrinwdavidson@gmail.com
%   date: 01.07.22
%%-------------------------------------------------------------------------
%%  configure
%   first set the important paths that we will use ::
cmip5_path = '/Volumes/data/CMIP5/output1/';

%   set variable paths ::
%%% u ::
lgm_variable_path = 'lgm/mon/atmos/Amon/r1i1p1/ua/';
lgm_paths_u = {cmip5_path, lgm_variable_path};
pic_variable_path = 'piControl/mon/atmos/Amon/r1i1p1/ua/';
pic_paths_u = {cmip5_path, pic_variable_path};

%%% v ::
lgm_variable_path = 'lgm/mon/atmos/Amon/r1i1p1/va/';
lgm_paths_v = {cmip5_path, lgm_variable_path};
pic_variable_path = 'piControl/mon/atmos/Amon/r1i1p1/va/';
pic_paths_v = {cmip5_path, pic_variable_path};

%   choose variables ::
variable_u = 'ua';
variable_v = 'va';

%%  set model parameters
%   write down the products that you want of the form {institute, model} ::
products = {'NCAR', 'CCSM4'; ...
            'MRI', 'MRI-CGCM3'; ...
            'LASG-CESS', 'FGOALS-g2'; ...
            'IPSL', 'IPSL-CM5A-LR'; ...
            'MPI-M', 'MPI-ESM-P'; ...
            'CNRM-CERFACS', 'CNRM-CM5'; ...
            'MIROC', 'MIROC-ESM'};

%   set the seasonal averaging ::
seasons.names = {'Winter', 'Spring', 'Summer', 'Autumn'};  % meteorological seasons
seasons.north = [12, 1, 2; ...
                 3, 4, 5; ...
                 6, 7, 8; ...
                 9, 10, 11];
seasons.south = [6, 7, 8; ...
                 9, 10, 11; ...
                 12, 1, 2; ...
                 3, 4, 5];

%   set uvic grid paths ::
uvic_grid_path = [input_path 'uvic/grid.mat'];

%%  read data
%%% lgm ::
cmip5_u10_lgm_rawData_monthly.u = read_data(variable_u, products, lgm_paths_u);
cmip5_u10_lgm_rawData_monthly.v = read_data(variable_v, products, lgm_paths_v);

%%% pic ::
cmip5_sic_pic_rawData_monthly.u = read_data(variable, products, pic_paths.u);
cmip5_sic_pic_rawData_monthly.v = read_data(variable, products, pic_paths.v);  %!<- I am here ->!%

%%  interpolate data
cmip5_sic_lgm_uvic_monthly = interp_data(cmip5_sic_lgm_rawData_monthly, uvic_grid_path, variable, products);
cmip5_sic_pic_uvic_monthly = interp_data(cmip5_sic_pic_rawData_monthly, uvic_grid_path, variable, products);

%%  make seasonal data
cmip5_sic_lgm_uvic_seasonal = make_seasons(cmip5_sic_lgm_uvic_monthly, seasons, uvic_grid_path);
cmip5_sic_pic_uvic_seasonal = make_seasons(cmip5_sic_pic_uvic_monthly, seasons, uvic_grid_path);

%%  calculate statistics
cmip5_sic_lgm_uvic_seasonal_stats = calc_seasonal_stats(cmip5_sic_lgm_uvic_seasonal, uvic_grid_path);
cmip5_sic_pic_uvic_seasonal_stats = calc_seasonal_stats(cmip5_sic_pic_uvic_seasonal, uvic_grid_path);

%%  save
save([output_path 'cmip5/cmip5_sic_lgm_uvic_seasonal_stats.mat'], 'cmip5_sic_lgm_uvic_seasonal_stats');
save([output_path 'cmip5/cmip5_sic_pic_uvic_seasonal_stats.mat'], 'cmip5_sic_pic_uvic_seasonal_stats');

%%  end program
