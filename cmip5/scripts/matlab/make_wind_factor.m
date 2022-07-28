%%=========================================================================
%   make_wind_factor
%%-------------------------------------------------------------------------
%   purpose: to make a pic to lgm wind factor for core-2 winds.
%   author: perrin w. davidson
%   contact: perrinwdavidson@gmail.com
%   date: 28.07.22
%%=========================================================================
%%  get core grid
%   get vectors
x = ncread(fullfile('data', 'exp_raw', 'core2', 'u_10.15JUNE2009.nc'), 'LON');
y = ncread(fullfile('data', 'exp_raw', 'core2', 'u_10.15JUNE2009.nc'), 'LAT');
t = ncread(fullfile('data', 'exp_raw', 'core2', 'u_10.15JUNE2009.nc'), 'TIME');

%   make grid ::
[core_lat, core_lon] = meshgrid(y, x);  

%   get lengths ::
nx = length(x); 
ny = length(y);
nt = length(t);

%%   make full extent factors
%    base ::
one_array = ones(size(core_lat)); 

%    0.5 factor ::
factor_05_90S90N = 0.5 .* one_array; 

%    1.5 factor ::
factor_15_90S90N = 1.5 .* one_array; 

%%   make northern latitude factors 
%    set extent ::
lat_extent_min = -50; 
lat_extent_max = 50; 

%    make 0.5 factor ::
factor_05_50S50N = factor_05_90S90N;
factor_05_50S50N(:, (y > lat_extent_min) & (y < lat_extent_max), :) = 1; 

%    make 1.5 factor ::
factor_15_50S50N = factor_15_90S90N;
factor_15_50S50N(:, (y > lat_extent_min) & (y < lat_extent_max), :) = 1;

%%   expand to 6-hourly
%    full ::
factor_05_90S90N = repmat(factor_05_90S90N, [1 1 nt]); 
factor_15_90S90N = repmat(factor_15_90S90N, [1 1 nt]); 

%    high latitude ::
factor_05_50S50N = repmat(factor_05_50S50N, [1 1 nt]); 
factor_15_50S50N = repmat(factor_15_50S50N, [1 1 nt]); 

%%   write data to netcdf4 files
%    create ::
%%%  lon ::
nccreate(fullfile('data', 'sims', 'wind_factor', 'wind_factor_90S90N.nc'), 'lon', 'dimensions', {'lon', nx});
nccreate(fullfile('data', 'sims', 'wind_factor', 'wind_factor_50S50N.nc'), 'lon', 'dimensions', {'lon', nx});

%%%  lat ::
nccreate(fullfile('data', 'sims', 'wind_factor', 'wind_factor_90S90N.nc'), 'lat', 'dimensions', {'lat', ny});
nccreate(fullfile('data', 'sims', 'wind_factor', 'wind_factor_50S50N.nc'), 'lat', 'dimensions', {'lat', ny});

%%%  time ::
nccreate(fullfile('data', 'sims', 'wind_factor', 'wind_factor_90S90N.nc'), 'time', 'dimensions', {'time', nt});
nccreate(fullfile('data', 'sims', 'wind_factor', 'wind_factor_50S50N.nc'), 'time', 'dimensions', {'time', nt});

%%%  0.5 factor ::
nccreate(fullfile('data', 'sims', 'wind_factor', 'wind_factor_90S90N.nc'), 'windfactor_05', 'dimensions', {'lon', nx, 'lat', ny, 'time', nt});
nccreate(fullfile('data', 'sims', 'wind_factor', 'wind_factor_50S50N.nc'), 'windfactor_05', 'dimensions', {'lon', nx, 'lat', ny, 'time', nt});

%%%  1.5 factor ::
nccreate(fullfile('data', 'sims', 'wind_factor', 'wind_factor_90S90N.nc'), 'windfactor_15', 'dimensions', {'lon', nx, 'lat', ny, 'time', nt});
nccreate(fullfile('data', 'sims', 'wind_factor', 'wind_factor_50S50N.nc'), 'windfactor_15', 'dimensions', {'lon', nx, 'lat', ny, 'time', nt});

%    write ::
%%%  lon ::
ncwrite(fullfile('data', 'sims', 'wind_factor', 'wind_factor_90S90N.nc'), 'lon', x);
ncwrite(fullfile('data', 'sims', 'wind_factor', 'wind_factor_50S50N.nc'), 'lon', x);

%%%  lat ::
ncwrite(fullfile('data', 'sims', 'wind_factor', 'wind_factor_90S90N.nc'), 'lat', y);
ncwrite(fullfile('data', 'sims', 'wind_factor', 'wind_factor_50S50N.nc'), 'lat', y);

%%%  time ::
ncwrite(fullfile('data', 'sims', 'wind_factor', 'wind_factor_90S90N.nc'), 'time', t);
ncwrite(fullfile('data', 'sims', 'wind_factor', 'wind_factor_50S50N.nc'), 'time', t);

%%%  0.5 factor ::
ncwrite(fullfile('data', 'sims', 'wind_factor', 'wind_factor_90S90N.nc'), 'windfactor_05', factor_05_90S90N);
ncwrite(fullfile('data', 'sims', 'wind_factor', 'wind_factor_50S50N.nc'), 'windfactor_05', factor_05_50S50N);

%%%  1.5 factor ::
ncwrite(fullfile('data', 'sims', 'wind_factor', 'wind_factor_90S90N.nc'), 'windfactor_15', factor_15_90S90N);
ncwrite(fullfile('data', 'sims', 'wind_factor', 'wind_factor_50S50N.nc'), 'windfactor_15', factor_15_50S50N);

%%=========================================================================
