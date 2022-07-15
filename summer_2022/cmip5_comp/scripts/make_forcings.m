%%  make_forcings
%%-------------------------------------------------------------------------
%   purpose: compile forcings to be read into tmm/inertgasgasex_l13_xatm
%   author: perrin w. davidson
%   contact: perrinwdavidson@gmail.com
%   date: 15.07.22
%%-------------------------------------------------------------------------
%%  make sea ice 
sea_ice_cmip5{1} = cmip5_sic_pic_uvic_monthly; 
sea_ice_cmip5{2} = cmip5_sic_lgm_uvic_monthly; 

%%	save data
save(fullfile(output_path, 'cmip5', 'sea_ice_cmip5.mat'), 'sea_ice_cmip5');

%%  end program