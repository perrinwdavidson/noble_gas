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

%%  read data 
%%% lgm ::
cmip5_v10_lgm_rawData_monthly = read_data(variable, products, lgm_paths);
cmip5_v10_pic_rawData_monthly = read_data(variable, products, pic_paths);

%%  interpolate data
%%% lgm ::
cmip5_v10_lgm_uvic_monthly = interp_data(cmip5_v10_lgm_rawData_monthly, uvic_grid_path, variable, products);
cmip5_v10_pic_uvic_monthly = interp_data(cmip5_v10_pic_rawData_monthly, uvic_grid_path, variable, products);

%%  calculate statistics
cmip5_v10_lgm_uvic_monthly_stats = calc_monthly_stats(cmip5_v10_lgm_uvic_monthly, uvic_grid_path, variable);
cmip5_v10_pic_uvic_monthly_stats = calc_monthly_stats(cmip5_v10_pic_uvic_monthly, uvic_grid_path, variable);

%%  save
%   monthly arrays ::
save([output_path 'cmip5/cmip5_v10_lgm_uvic_monthly_stats.mat'], 'cmip5_v10_lgm_uvic_monthly_stats');
save([output_path 'cmip5/cmip5_v10_pic_uvic_monthly_stats.mat'], 'cmip5_v10_pic_uvic_monthly_stats');

%   statistics ::
save([output_path 'cmip5/cmip5_v10_lgm_uvic_monthly.mat'], 'cmip5_v10_lgm_uvic_monthly');
save([output_path 'cmip5/cmip5_v10_pic_uvic_monthly.mat'], 'cmip5_v10_pic_uvic_monthly');

%%  end program