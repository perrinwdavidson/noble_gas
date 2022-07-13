%%  compare_v10 -- compiling and calculating stats for cmip5 v10
%%-------------------------------------------------------------------------
%   purpose: to calculate cmip5 geographic distributions of merid. windspeed
%   author: perrin w. davidson
%   contact: perrinwdavidson@gmail.com
%   date: 01.07.22
%%-------------------------------------------------------------------------
%%  configure
%   first set the important paths that we will use ::
cmip5_path = '/Volumes/data/CMIP5/output1/';

%   set variable paths ::
lgm_variable_path = 'lgm/mon/atmos/Amon/r1i1p1/va/';
lgm_paths = {cmip5_path, lgm_variable_path};
pic_variable_path = 'piControl/mon/atmos/Amon/r1i1p1/va/';
pic_paths = {cmip5_path, pic_variable_path};

%   choose variables ::
variable = 'va';

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
cmip5_v10_lgm_rawData_monthly = read_data(variable, products, lgm_paths);
cmip5_v10_pic_rawData_monthly = read_data(variable, products, pic_paths);

%%  interpolate data
%%% lgm ::
cmip5_v10_lgm_uvic_monthly = interp_data(cmip5_v10_lgm_rawData_monthly, uvic_grid_path, variable, products);
cmip5_v10_pic_uvic_monthly = interp_data(cmip5_v10_pic_rawData_monthly, uvic_grid_path, variable, products);

%%  make seasonal data
cmip5_v10_lgm_uvic_seasonal = make_seasons(cmip5_v10_lgm_uvic_monthly, seasons, uvic_grid_path);
cmip5_v10_pic_uvic_seasonal = make_seasons(cmip5_v10_pic_uvic_monthly, seasons, uvic_grid_path);

%%  calculate statistics
cmip5_v10_lgm_uvic_seasonal_stats = calc_seasonal_stats(cmip5_v10_lgm_uvic_seasonal, uvic_grid_path);
cmip5_v10_pic_uvic_seasonal_stats = calc_seasonal_stats(cmip5_v10_pic_uvic_seasonal, uvic_grid_path);

%%  save
save([output_path 'cmip5/cmip5_v10_lgm_uvic_seasonal_stats.mat'], 'cmip5_v10_lgm_uvic_seasonal_stats');
save([output_path 'cmip5/cmip5_v10_pic_uvic_seasonal_stats.mat'], 'cmip5_v10_pic_uvic_seasonal_stats');

%%  end program