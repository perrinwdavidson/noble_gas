%%  make_forcings
%%-------------------------------------------------------------------------
%   purpose: compile forcings to be read into tmm/inertgasgasex_l13_xatm
%   author: perrin w. davidson
%   contact: perrinwdavidson@gmail.com
%   date: 15.07.22
%%-------------------------------------------------------------------------
%%  collect by model
%   set dimensions ::
NUMMON = size(cmip5_sic_pic_uvic_monthly, 2);
NUMMOD = size(cmip5_sic_pic_uvic_monthly{1, 1}, 3);

%   preallocate ::
pic_sic = cell([1, NUMMOD]);
lgm_sic = cell([1, NUMMOD]);

%   collect data in array ::
for iMon = 1 : 1 : NUMMON

    for iMod = 1 : 1 : NUMMOD

        pic_sic{1, iMod}(:, :, iMon) = cmip5_sic_pic_uvic_monthly{1, iMon}(:, :, iMod);
        lgm_sic{1, iMod}(:, :, iMon) = cmip5_sic_lgm_uvic_monthly{1, iMon}(:, :, iMod);

    end

end

%%  make final sea ice array
sea_ice_cmip5{1} = pic_sic; 
sea_ice_cmip5{2} = lgm_sic; 

%%	save data
save(fullfile(output_path, 'cmip5', 'sea_ice_cmip5.mat'), 'sea_ice_cmip5');

%%  end program