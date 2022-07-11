function time_average = monthly_mean(raw_data, products)
%--------------------------------------------------------------------------
%   purpose: calculating climatologies over monthly time periods.
%   author: perrin w. davidson
%   contact: perrinwdavidson@gmail.com
%   date: 06.07.22
%--------------------------------------------------------------------------
%   get number of models ::
NUMMOD = size(raw_data, 2); 

%   pre-allocate space for final arrage ::
time_average = cell(1, NUMMOD);

%   loop through all models and average ::
for iMod = 1 : 1 : NUMMOD

	%    grab data ::
	get_data = raw_data{1, iMod};

	%    get basic dimensions ::
    	NUMX = size(get_data.value, 1); 
    	NUMY = size(get_data.value, 2); 
    	NUMTIME = size(get_data.value, 3); 
    	NUMMON = 12; 

    	%   calculations ::
    	%%% pre-allocate final array ::
    	model_time_average = NaN(NUMX, NUMY, NUMMON); 

    	%%% calculate climatology (monthly mean) ::
    	for iMonth = 1 : 1 : NUMMON

        %   calculate mean ::
        	model_time_average(:, :, iMonth) = mean(get_data.value(:, :, iMonth : NUMMON : end), ...
                                     			3, ...
							'omitnan');

    	end
    
    %   store data ::
    time_average{iMod} = {model_time_average, get_data.lon, get_data.lat, 1 : 1 : NUMMON};
                      
    %   lemme know how it is going ::
    disp(['Done monthly averaging model: ' products{iMod, 1}]);
    
end

%--------------------------------------------------------------------------
end
