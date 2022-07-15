%%  run_cmip5_comp
%%-------------------------------------------------------------------------
%   purpose: to calculate cmip5 geographic distributions of windspeed (u10, v10)
%            and sea ice fraction (sic).
%   author: perrin w. davidson
%   contact: perrinwdavidson@gmail.com
%   date: 01.07.22
%%-------------------------------------------------------------------------
%%  configure
%   deal with the environment ::
clear; 
close;
clc;

%   set input and output paths ::
input_path = 'io/inputs/';
output_path = 'io/outputs/';

%%  set global model parameters
%   write down the products that you want of the form {institute, model} ::
products = {'NCAR', 'CCSM4'; ...
            'MRI', 'MRI-CGCM3'; ...
            'LASG-CESS', 'FGOALS-g2'; ...
            'IPSL', 'IPSL-CM5A-LR'; ...
            'MPI-M', 'MPI-ESM-P'; ...
            'CNRM-CERFACS', 'CNRM-CM5'; ...
            'MIROC', 'MIROC-ESM'};

%   set the seasonal averaging ::
seasons.names = {'Winter', 'Spring', 'Summer', 'Autumn'};  % meteorological seasons
seasons.north = [12, 1, 2; ...
                 3, 4, 5; ...
                 6, 7, 8; ...
                 9, 10, 11]; 
seasons.south = [6, 7, 8; ...
                 9, 10, 11; ...
                 12, 1, 2; ...
                 3, 4, 5];

%   set uvic grid paths ::
uvic_grid_path = [input_path 'uvic/grid.mat'];

%%  compare sea ice fraction
compile_sic; 

%%  compare windspeed 
compile_u10; 
compile_v10;

%%  calculate wind factor
calculate_delta; 

%%  finalize forcings
make_forcings; 

%%  end program