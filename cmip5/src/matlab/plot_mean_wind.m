function plot_mean_wind(variable, filename1, filename2)
%--------------------------------------------------------------------------
%   purpose: plotting zonal mean wind data.
%   author: perrin w. davidson
%   contact: perrinwdavidson@gmail.com
%   date: 06.07.22
%--------------------------------------------------------------------------
%%  configure
%   let me know what is going on ::
disp(append('Plotting zonally averaged ', upper(variable)));

%   make month array ::
month_names = {'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'};

%   get variables names ::
group_names = ncread(filename, 'group_names');
variable_names = ncread(filename, 'variable_names');

%   get number of models ::
NUMMOD = size(group_names, 1);

%   set number of months ::
NUMMON = 12;

%%  loop through all models
for iMod = 1 : 1 : NUMMOD

    %%  load data ::
    %   file 1 ::
    model_data_1 = ncread(filename1, append(group_names{iMod}, variable_names{iMod}));
    model_lat_1 = ncread(filename1, append(group_names{iMod}, 'lat'));

    %   file 2 ::
    model_data_2 = ncread(filename2, append(group_names{iMod}, variable_names{iMod}));
    model_lat_2 = ncread(filename2, append(group_names{iMod}, 'lat'));

    %%  plot ::
    %   start plot ::        
    close;
    t = tiledlayout(3, 4, 'tileSpacing', 'compact');

    %   loop through all months ::
    for iMon = 1 : 1 : NUMMON

        %   get monthly data ::
        model_data_month = model_data(:, iMon);

        %   plot contourf ::
        nexttile();
        hold('on');
        plot(model_data_1, model_lat_1, '-k', 'lineWidth', 1.5);
        plot(model_data_2, model_lat_2, '--k', 'lineWidth', 1.5);
        hold('off');
        legend('LGM', 'PIC')
        xlabel('Wind Speed (m s^{-1})')
        ylabel('Latitude')
        title(month_names(iMon));

    end

    %   title ::
    title(t, append('Zonally Averaged ', products{iMod, 1}, ' ', upper(variable)), 'fontWeight', 'bold')

    %   set and save plot ::
    set(gcf, 'position', [0, 0, 1920, 1000]); 
    exportgraphics(t, fullfile('plots', 'wind', strcat(variable, '_', age, '_', products{iMod, 1}, '.png')), 'resolution', 300); 

end

%--------------------------------------------------------------------------
end