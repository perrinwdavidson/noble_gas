%%  compare_sic -- compiling and calculating stats for cmip5 sic
%%-------------------------------------------------------------------------
%   purpose: to calculate cmip5 geographic distributions of sea ice 
%            fraction (sic).
%   author: perrin w. davidson
%   contact: perrinwdavidson@gmail.com
%   date: 01.07.22
%%-------------------------------------------------------------------------
%%  configure
%   first set the important paths that we will use ::
cmip5_path = '/Volumes/data/CMIP5/output1/';
lgm_variable_path = 'lgm/mon/seaIce/OImon/r1i1p1/sic';
lgm_paths = {cmip5_path, lgm_variable_path};
pic_variable_path = '/piControl/mon/seaIce/OImon/r1i1p1/sic/';
pic_paths = {cmip5_path, pic_variable_path};

%   choose variable ::
variable = 'sic';

%%  read data
cmip5_sic_lgm_rawData_monthly = read_data(variable, products, lgm_paths);
cmip5_sic_pic_rawData_monthly = read_data(variable, products, pic_paths);

%%  interpolate data
cmip5_sic_lgm_uvic_monthly = interp_data(cmip5_sic_lgm_rawData_monthly, uvic_grid_path, variable, products); 
cmip5_sic_pic_uvic_monthly = interp_data(cmip5_sic_pic_rawData_monthly, uvic_grid_path, variable, products); 

%%  calculate statistics
cmip5_sic_lgm_uvic_monthly_stats = calc_monthly_stats(cmip5_sic_lgm_uvic_monthly, uvic_grid_path); 
cmip5_sic_pic_uvic_monthly_stats = calc_monthly_stats(cmip5_sic_pic_uvic_monthly, uvic_grid_path); 

%%  save
%   monthly arrays ::
save([output_path 'cmip5/cmip5_sic_lgm_uvic_monthly_stats.mat'], 'cmip5_sic_lgm_uvic_monthly_stats');
save([output_path 'cmip5/cmip5_sic_pic_uvic_monthly_stats.mat'], 'cmip5_sic_pic_uvic_monthly_stats');

%   statistics ::
save([output_path 'cmip5/cmip5_sic_lgm_uvic_monthly.mat'], 'cmip5_sic_lgm_uvic_monthly');
save([output_path 'cmip5/cmip5_sic_pic_uvic_monthly.mat'], 'cmip5_sic_pic_uvic_monthly');

%%  end program