function write_cmip5_interp_variable(mod_lon, mod_lat, cmip_data, variable, products, age, filename)
%--------------------------------------------------------------------------
%   purpose: saving interpolated cmip data to a netcdf file
%   author: perrin w. davidson
%   contact: perrinwdavidson@gmail.com
%   date: 06.07.22
%--------------------------------------------------------------------------
%%  configure
%   let me know what is going on ::
disp(append('Writing interpolated CMIP5 model data for ', upper(variable), ' to a netCDF file.'));

%   get all models ::
NUMMOD = length(cmip_data); 

%   create and open netcdf file ::
if isfile(filename)

    delete(filename)

end
nc_id = netcdf.create(filename, 'NETCDF4');  

%   make paths ::
group_names = cell(NUMMOD, 1);
variable_names = cell(NUMMOD, 1);

%%  write data
%   loop through all models ::
for iMod = 1 : 1 : NUMMOD

    %   get data ::
    mod_data = cmip_data{iMod}; 

    %   make group and variable names ::
    group_name = append(products{iMod, 1}, ' ', products{iMod, 2}); 
    variable_name = append(group_name, ' ' , age, ' ', upper(variable)); 

    %   define ::
    %-  make group ::
    mod_group_id = netcdf.defGrp(nc_id, group_name);

    %-  make dimensions ::
    x_id = netcdf.defDim(mod_group_id, 'x', size(mod_data, 1));
    y_id = netcdf.defDim(mod_group_id, 'y', size(mod_data, 2));
    t_id = netcdf.defDim(mod_group_id, 'month', size(mod_data, 3));

    %-  make variables ::
    mod_data_id = netcdf.defVar(mod_group_id, variable_name, 'NC_DOUBLE', [x_id, y_id, t_id]);
    mod_lon_id = netcdf.defVar(mod_group_id, 'lon', 'NC_DOUBLE', [x_id, y_id]);
    mod_lat_id = netcdf.defVar(mod_group_id, 'lat', 'NC_DOUBLE', [x_id, y_id]);

    %-  define fill values ::
    netcdf.defVarFill(mod_group_id, mod_data_id, false, -99999);
    netcdf.defVarFill(mod_group_id, mod_lon_id, true, -99999);
    netcdf.defVarFill(mod_group_id, mod_lat_id, true, -99999);

    %-  end define mode ::
    netcdf.endDef(nc_id);

    %   write ::
    netcdf.putVar(mod_group_id, mod_data_id, mod_data)
    netcdf.putVar(mod_group_id, mod_lon_id, mod_lon)
    netcdf.putVar(mod_group_id, mod_lat_id, mod_lat)

    %   display ::
    disp(append('Done writing data for ', group_name))

    %   store paths ::
    group_names{iMod} = ['/' group_name '/'];
    variable_names{iMod} = variable_name;

end

%   save group paths ::
%-  define dimensions
num_names_id = netcdf.defDim(nc_id, 'num_mod', NUMMOD);

%-  define variables ::
group_names_id = netcdf.defVar(nc_id, 'group_names', 'NC_STRING', num_names_id);
variable_names_id = netcdf.defVar(nc_id, 'variable_names', 'NC_STRING', num_names_id);

%-  end definition ::
netcdf.endDef(nc_id);

%-  place the variables ::
netcdf.putVar(nc_id, group_names_id, group_names)
netcdf.putVar(nc_id, variable_names_id, variable_names)

%   close file ::
netcdf.close(nc_id);

%--------------------------------------------------------------------------
end