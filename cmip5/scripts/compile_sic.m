%%  compare_sic -- compiling and calculating stats for cmip5 sic
%%-------------------------------------------------------------------------
%   purpose: to compile cmip5 sea ice fraction (sic).
%   author: perrin w. davidson
%   contact: perrinwdavidson@gmail.com
%   date: 01.07.22
%%-------------------------------------------------------------------------
%%  configure
%   first set the important paths that we will use ::
cmip5_path = "/Volumes/data/CMIP5/output1/";
lgm_variable_path = "lgm/mon/seaIce/OImon/r1i1p1/sic";
lgm_paths = [cmip5_path, lgm_variable_path];
pic_variable_path = "/piControl/mon/seaIce/OImon/r1i1p1/sic/";
pic_paths = [cmip5_path, pic_variable_path];

%   choose variable ::
variable = "sic";

%%  read data
cmip5_sic_lgm_rawData_monthly = read_data(variable, products, lgm_paths);
cmip5_sic_pic_rawData_monthly = read_data(variable, products, pic_paths); 

%%  make netcdf


%%  save
save(fullfile(output_path, "cmip5", "lgm", "cmip5_sic_lgm_uvic_monthly.mat"), "cmip5_sic_lgm_uvic_monthly");
save(fullfile(output_path, "cmip5", "pic", "cmip5_sic_pic_uvic_monthly.mat"), "cmip5_sic_pic_uvic_monthly");

%%  end program