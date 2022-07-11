function seasonal_data = make_seasons(monthly_data, seasons, uvic_grid_path)
%--------------------------------------------------------------------------
%   purpose: make seasonal array of cmip5 data, by meteorological month.
%   this is to say that 1M = (12N, 6S), and so forth.
%   author: perrin w. davidson
%   contact: perrinwdavidson@gmail.com
%   date: 06.07.22
%--------------------------------------------------------------------------
%%  let me know what is going on
disp('Making seasonal data array.'); 

%%  load data
load(uvic_grid_path, 'y');

%%  get initial data
%   get the number of seasons ::
NUMSEASON = length(seasons.names); 

%   get the number of models ::
NUMMON = size(monthly_data, 2); 

%%  pre-allocate array
seasonal_data = cell(1, NUMMON); 

%%  make seasonal array
%   loop through all northern hemisphere seasonal arrays :: 
countMonth = 1;
for iSeason = 1 : 1 : NUMSEASON

    %  get north seasonal data ::
    for iN = seasons.north(iSeason, :)

        seasonal_data{countMonth}(:, y > 0, :) = monthly_data{iN}(:, y > 0, :);
        countMonth = countMonth + 1; 

    end
    
end

%   loop through all southern hemisphere seasonal arrays :: 
countMonth = 1;
for iSeason = 1 : 1 : NUMSEASON
    
    %  get south seasonal data ::
    for iS = seasons.south(iSeason, :)

        seasonal_data{countMonth}(:, y < 0, :) = monthly_data{iS}(:, y < 0, :);
        countMonth = countMonth + 1;

    end

end
    
%--------------------------------------------------------------------------
end