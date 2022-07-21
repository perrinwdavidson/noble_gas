function plot_mean_wind(variable, filename1, filename2, products, age)
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
%   filename 1 ::
group_names_1 = ncread(filename1, 'group_names');
variable_names_1 = ncread(filename1, 'variable_names');

%   filename 2 ::
group_names_2 = ncread(filename2, 'group_names');
variable_names_2 = ncread(filename2, 'variable_names');

%   get number of models ::
NUMMOD = size(group_names_1, 1);

%   set number of months ::
NUMMON = length(month_names);

%%  loop through all models
for iMod = 1 : 1 : NUMMOD

    %%  load data ::
    %   file 1 ::
    model_data_1 = ncread(filename1, append(group_names_1{iMod}, variable_names_1{iMod}));
    model_lat_1 = ncread(filename1, append(group_names_1{iMod}, 'lat'));

    %   file 2 ::
    model_data_2 = ncread(filename2, append(group_names_2{iMod}, variable_names_2{iMod}));
    model_lat_2 = ncread(filename2, append(group_names_2{iMod}, 'lat'));

    %%  plot ::
    %   start plot ::        
    close;
    t = tiledlayout(3, 4, 'tileSpacing', 'compact');

    %   loop through all months ::
    for iMon = 1 : 1 : NUMMON

        %   get monthly data ::
        model_data_month_1 = model_data_1(:, iMon);
        model_data_month_2 = model_data_2(:, iMon);

        %   plot contourf ::
        nexttile();
        hold('on');
        plot(model_data_month_1, model_lat_1, '-k', 'lineWidth', 1.5);
        plot(model_data_month_2, model_lat_2, '--k', 'lineWidth', 1.5);
        hold('off');
        title(month_names(iMon));
        set(gca, 'box', 'on')

    end

    %   title and legend ::
    %-  legend ::
    lg = legend('LGM', 'PIC');
    lg.Layout.Tile = 'east';

    %-  title and labels ::
    title(t, append('Zonally Averaged ', products{iMod, 1}, ' ', upper(variable)), 'fontWeight', 'bold')
    xlabel(t, 'Wind Speed (m s^{-1})')
    ylabel(t, 'Latitude')

    %   set and save plot ::
    set(gcf, 'position', [0, 0, 800, 1000]); 
    exportgraphics(gcf, fullfile('plots', 'wind', 'zonal_mean', strcat(variable, '_zonal_mean_', age, '_', products{iMod, 1}, '.png')), 'resolution', 300); 

end

%--------------------------------------------------------------------------
end