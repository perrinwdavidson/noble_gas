function zonal_mean = calc_zonal_mean(lat, data)
%--------------------------------------------------------------------------
%   purpose: calculating zonal mean windspeed for cmip5 data at core-2 grid
%   author: perrin w. davidson
%   contact: perrinwdavidson@gmail.com
%   date: 06.07.22
%--------------------------------------------------------------------------
%%  configure
%   let me know what is going on ::
disp("Calculating zonal mean windspeed.");

%   get dimensions ::
NUMMOD = size(data, 2); 

%%  preallocate
zonal_mean = cell(1, NUMMOD); 

%%  calculate average
%   loop through all models ::
for iMod = 1 : 1 : NUMMOD

    %   get data ::
    mod_data = data{iMod};

    %   calculate zonal mean ::
    zonal_mean{iMod}.value = squeeze(mean(mod_data, 1, "omitnan")); 

    %   calculate zonal mean latitude ::
    zonal_mean{iMod}.lat = mean(lat, 1, "omitnan")';

end

%--------------------------------------------------------------------------
end