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

%%  compare sea ice fraction
compare_sic; 

%%  compare windspeed 
compare_u10; 
compare_v10;

%%  end program
