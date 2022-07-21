function plot_ice(filename1, products, variable, age)
%--------------------------------------------------------------------------
%   purpose: plotting sea ice.
%   author: perrin w. davidson
%   contact: perrinwdavidson@gmail.com
%   date: 06.07.22
%--------------------------------------------------------------------------
%%  configure 
%   add paths ::
addpath('/Users/perrindavidson/Documents/MATLAB/toolboxes/plotting/m_map');

%   let me know what is going on ::
disp(append('Plotting ', upper(age), ' ', upper(variable))); 

%   make month array ::
month_names = {'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'};

%   get variables names ::
group_names = ncread(filename1, 'group_names');
variable_names = ncread(filename1, 'variable_names');

%   get number of models ::
NUMMOD = size(group_names, 1);

%   set number of months ::
NUMMON = 12;

%   set colors ::
color_limits = 0 : 0.1 : 1; 
color_map = bone(10); 

%%  loop through all models
for iMod = 1 : 1 : NUMMOD

    %%  load data ::
    model_data = ncread(filename1, append(group_names{iMod}, variable_names{iMod}));
    model_lon = ncread(filename1, append(group_names{iMod}, 'lon'));
    model_lat = ncread(filename1, append(group_names{iMod}, 'lat'));

    %%  plot ::
    %   start plot ::        
    close;
    t = tiledlayout(3, 4, 'tileSpacing', 'compact');

    %   loop through all months ::
    for iMon = 1 : 1 : NUMMON

        %   get monthly data ::
        model_data_month = model_data(:, :, iMon);

        %   plot contourf ::
        nexttile();
        m_proj('miller', 'lon', [0 360], 'lat', [min(model_lat, [], 'all') max(model_lat, [], 'all')]);
        m_contourf(model_lon, model_lat, model_data_month, color_limits, 'edgecolor', 'none');
        m_coast('patch', [.8 .8 .8]);
        m_grid('box', 'fancy', 'tickdir', 'in');
        colormap(color_map);
        color_ax = colorbar('eastOutside');
        set(color_ax, 'tickdir', 'in', 'ticks', 0 : 0.2 : 1, 'xLim', [0, 1]);
        title(month_names(iMon));

    end

    %   title ::
    title(t, append(upper(age), ' ', products{iMod, 1}, ' Sea Ice Fraction'), 'fontWeight', 'bold')

    %   set and save plot ::
    set(gcf, 'position', [0, 0, 1920, 1000]); 
    exportgraphics(t, fullfile('plots', 'ice', age, strcat(variable, '_', age, '_', products{iMod, 1}, '.png')), 'resolution', 300); 

end

%--------------------------------------------------------------------------
end