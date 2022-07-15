function new_data = concat_interp(lat, lon, time, data, core_lat, core_lon, core_time)
%--------------------------------------------------------------------------
%   purpose: concatenate and interpolate data for make_forcings
%   author: perrin w. davidson
%   contact: perrinwdavidson@gmail.com
%   date: 14.07.22
%--------------------------------------------------------------------------

    %   concatenate ::
    val = cat(3, data(:, :, 11 : 12), data); 
    val = cat(3, val, data(:, :, 1 : 2)); 
    
    %   interpolate ::
    new_data = interp3(lat, lon, time, val, core_lat, core_lon, core_time);

%--------------------------------------------------------------------------
end