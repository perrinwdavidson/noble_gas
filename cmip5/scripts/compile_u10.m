%%  compare_u10 -- compiling and calculating stats for cmip5 u10
%%-------------------------------------------------------------------------
%   purpose: to calculate cmip5 geographic distributions of zonal windspeed
%   author: perrin w. davidson
%   contact: perrinwdavidson@gmail.com
%   date: 01.07.22
%%-------------------------------------------------------------------------
%%  configure
%   first set the important paths that we will use ::
cmip5_path = '/Volumes/data/CMIP5/output1/';

%   set variable paths ::
lgm_variable_path = 'lgm/mon/atmos/Amon/r1i1p1/ua/';
lgm_paths = {cmip5_path, lgm_variable_path};
pic_variable_path = 'piControl/mon/atmos/Amon/r1i1p1/ua/';
pic_paths = {cmip5_path, pic_variable_path};

%   choose variables ::
variable = 'ua';

%%  read data 
%%% lgm ::
cmip5_u10_lgm_rawData_monthly = read_data(variable, products, lgm_paths);
cmip5_u10_pic_rawData_monthly = read_data(variable, products, pic_paths);

%%  interpolate data
%%% lgm ::
cmip5_u10_lgm_uvic_monthly = interp_data(cmip5_u10_lgm_rawData_monthly, uvic_grid_path, variable, products);
cmip5_u10_pic_uvic_monthly = interp_data(cmip5_u10_pic_rawData_monthly, uvic_grid_path, variable, products);

%%  calculate statistics
cmip5_u10_lgm_uvic_monthly_stats = calc_monthly_stats(cmip5_u10_lgm_uvic_monthly, uvic_grid_path, variable);
cmip5_u10_pic_uvic_monthly_stats = calc_monthly_stats(cmip5_u10_pic_uvic_monthly, uvic_grid_path, variable);

%%  save
%   monthly arrays ::
save([output_path 'cmip5/cmip5_u10_lgm_uvic_monthly_stats.mat'], 'cmip5_u10_lgm_uvic_monthly_stats');
save([output_path 'cmip5/cmip5_u10_pic_uvic_monthly_stats.mat'], 'cmip5_u10_pic_uvic_monthly_stats');

%   statistics ::
save([output_path 'cmip5/cmip5_u10_lgm_uvic_monthly.mat'], 'cmip5_u10_lgm_uvic_monthly');
save([output_path 'cmip5/cmip5_u10_pic_uvic_monthly.mat'], 'cmip5_u10_pic_uvic_monthly');

%%  end program