function write_uvic_zonal_windspeed(cmip_lat, cmip_data, age, filename)
%--------------------------------------------------------------------------
%   purpose: saving interpolated zonal windspeed uvic data to a netcdf file
%   author: perrin w. davidson
%   contact: perrinwdavidson@gmail.com
%   date: 06.07.22
%--------------------------------------------------------------------------
%%  let me know what is going on ::
disp(append('Writing zonally-averaged interpolated UVic model ', upper(age), ' windspeed data to a netCDF file.'));

%   create and open netcdf file ::
if isfile(filename)

    delete(filename);

end
nc_id = netcdf.create(filename, 'NETCDF4');  

%%  write data
%   get variable name ::
variable_name = append('UVic ', upper(age), ' Zonally Averaged Windspeed'); 

%   define ::
%-  make dimensions ::
y_id = netcdf.defDim(nc_id, 'y', size(cmip_data, 1));
t_id = netcdf.defDim(nc_id, 'month', size(cmip_data, 2));

%-  make variables ::
mod_data_id = netcdf.defVar(nc_id, variable_name, 'NC_DOUBLE', [y_id, t_id]);
mod_lat_id = netcdf.defVar(nc_id, 'lat', 'NC_DOUBLE', y_id);

%-  define fill values ::
netcdf.defVarFill(nc_id, mod_data_id, false, -99999);
netcdf.defVarFill(nc_id, mod_lat_id, true, -99999);

%-  end define mode ::
netcdf.endDef(nc_id);

%   write ::
netcdf.putVar(nc_id, mod_data_id, cmip_data)
netcdf.putVar(nc_id, mod_lat_id, cmip_lat)

%   close file ::
netcdf.close(nc_id);

%--------------------------------------------------------------------------
end