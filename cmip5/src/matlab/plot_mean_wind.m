function plot_mean_wind(variable, filename1, filename2)
%--------------------------------------------------------------------------
%   purpose: plotting zonal mean wind data.
%   author: perrin w. davidson
%   contact: perrinwdavidson@gmail.com
%   date: 06.07.22
%--------------------------------------------------------------------------
%%  let me know what is going on
disp(append('Plotting zonally averaged ', upper(variable)));

%%  make month array ::
month_names = {'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'};

%%  loop through all models
for iMod = 1 : 1 : NUMMOD

    %%  load data ::


    %%  plot ::    
    %   start plot ::   
    close;
    t = tiledlayout(3, 4, 'tileSpacing', 'compact');

    %   loop through all months ::
    for iMon = 1 : 1 : NUMMON

        %-  plot ::
        nexttile();
        

        title(month_names(iMon));

    end

    %   title ::
    title(t, append(upper(age), ' ', products{iMod, 1}, ' Sea Ice Fraction'), 'fontWeight', 'bold')

    %   set and save plot ::
    set(gcf, 'position', [0, 0, 1920, 1000]); 
    exportgraphics(t, fullfile('plots', age, strcat(variable, '_', age, '_', products{iMod, 1}, '.png')), 'resolution', 300); 

end

%--------------------------------------------------------------------------
end