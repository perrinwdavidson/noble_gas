%%  run_cmip5_comp
%%-------------------------------------------------------------------------
%   purpose: to calculate cmip5 geographic distributions of windspeed (ws)
%            and sea ice fraction (sic).
%   author: perrin w. davidson
%   contact: perrinwdavidson@gmail.com
%   date: 01.07.22
%%-------------------------------------------------------------------------
%%  configure
%   deal with the environment ::
clear; 
close;

%   set input and output paths ::
input_path = 'io/inputs/';
output_path = 'io/outputs/';

%%  compare sea ice fraction
compare_sic; 

%%  compare windspeed 
%compare_windspeed; 

%%  end program
