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