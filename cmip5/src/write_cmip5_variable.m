function write_cmip5_variable(cmip_data, variable, products, age, filename)
%--------------------------------------------------------------------------
%   purpose: saving raw cmip data to a netcdf file
%   author: perrin w. davidson
%   contact: perrinwdavidson@gmail.com
%   date: 06.07.22
%--------------------------------------------------------------------------
%%  let me know what is going o
disp(['Writing raw model data for ' upper(variable) ' to a netCDF file.']);

%   get all models ::
NUMMOD = length(cmip_data); 

%   create and open netcdf file ::
if isfile(filename)

    delete(filename)

end
nc_id = netcdf.create(filename, 'NETCDF4');  

%   make paths ::
group_paths = cell(NUMMOD, 1);

%   loop through all models ::
for iMod = 1 : 1 : NUMMOD

    %   get data ::
    mod_data = cmip_data{iMod}.value; 
    mod_lon = cmip_data{iMod}.lon;
    mod_lat = cmip_data{iMod}.lat; 

    %   make meshgrid if only a vector ::
    if (sum(size(mod_lon) == 1) > 0) || (sum(size(mod_lat) == 1) > 0)

        %   meshgrid ::
        [mod_lat, mod_lon] = meshgrid(mod_lat, mod_lon);

    end

    %   make group and variable names ::
    group_name = [products{iMod, 1} ' ' products{iMod, 2}]; 
    variable_name = [group_name ' ' age ' ' upper(variable)]; 

    %   define ::
    %-  make group ::
    mod_group_id = netcdf.defGrp(nc_id, group_name);

    %-  make dimensions ::
    x_id = netcdf.defDim(mod_group_id, "x", size(mod_data, 1));
    y_id = netcdf.defDim(mod_group_id, "y", size(mod_data, 2));
    t_id = netcdf.defDim(mod_group_id, "time", size(mod_data, 3));

    %-  make variables ::
    mod_data_id = netcdf.defVar(mod_group_id, variable_name, "NC_DOUBLE", [x_id, y_id, t_id]);
    mod_lon_id = netcdf.defVar(mod_group_id, "lon", "NC_DOUBLE", [x_id, y_id]);
    mod_lat_id = netcdf.defVar(mod_group_id, "lat", "NC_DOUBLE", [x_id, y_id]);

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
    disp(['Done writing data for ', group_name])

    %   store paths ::
    group_paths{iMod} = fullfile('/', group_name, variable_name);

end

%   save group paths ::
num_group_paths_id = netcdf.defDim(nc_id, "num_var", size(group_paths, 1));
group_paths_id = netcdf.defVar(nc_id, "variable_names", "NC_STRING", num_group_paths_id);
netcdf.endDef(nc_id);
netcdf.putVar(nc_id, group_paths_id, group_paths)

%   close file ::
netcdf.close(nc_id);

%--------------------------------------------------------------------------
end