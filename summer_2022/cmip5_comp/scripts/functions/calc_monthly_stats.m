function monthly_stats = calc_monthly_stats(monthly_data, uvic_grid_path, variable)
%--------------------------------------------------------------------------
%   purpose: calculate monthly statistics of cmip5 data seasonal array.
%   author: perrin w. davidson
%   contact: perrinwdavidson@gmail.com
%   date: 06.07.22
%--------------------------------------------------------------------------
%%  let me know what is going on
disp(['Calculating monthly statistics for ' variable]); 

%%  load data
load(uvic_grid_path, 'nx', 'ny');

%%  set dimensions
%   number of months ::
NUMMON = size(monthly_data, 2); 

%%  calculate monthly climatology
%   pre-allocate array ::
monthly_mean = NaN([nx, ny, NUMMON]); 
monthly_min = NaN([nx, ny, NUMMON]); 
monthly_max = NaN([nx, ny, NUMMON]); 
monthly_spread = NaN([nx, ny, NUMMON]); 

%   loop through all months ::
for iMon = 1 : 1 : NUMMON
    
    %   calculate mean ::
    monthly_mean(:, :, iMon) = mean(monthly_data{1, iMon}, 3, 'omitnan'); 

    %   calculate min ::
    monthly_min(:, :, iMon) = min(monthly_data{1, iMon}, [], 3, 'omitnan'); 

    %   calculate max ::
    monthly_max(:, :, iMon) = max(monthly_data{1, iMon}, [], 3, 'omitnan'); 

    %   calculate spread ::
    monthly_spread(:, :, iMon) = monthly_max(:, :, iMon) - monthly_min(:, :, iMon);
    
end

%%  save data
monthly_stats.mean = monthly_mean;
monthly_stats.min = monthly_min;
monthly_stats.max = monthly_max;
monthly_stats.spread = monthly_spread;

%--------------------------------------------------------------------------
end