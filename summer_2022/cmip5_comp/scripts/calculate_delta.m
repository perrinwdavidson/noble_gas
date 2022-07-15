%%	calc_delta
%%---------------------------------------------------------
%	purpose :: to calculate the multiplicative factor between the lgm and pic for windspeed.
%	this is to say that we want to estimate the lgm winds from the pic (modern CORE-2 winds) using:
%		u10_{lgm, core-2, i} = (u10_{lgm, cmip5_i} / u10_{pic, cmip5_i}) * u10_{pic, core-2},
%	where i indicates the ith model of the cmip5 ensemble.
%	author :: perrin w. davidson
%	date :: 13.07.2022
%	contact :: perrinwdavidson@gmail.com
%%---------------------------------------------------------
%%	load data
%	u10 ::
data{1} = u10_cmip5{1};
data{2} = u10_cmip5{2}; 

%	v10 ::
data{3} = v10_cmip5{1}; 
data{4} = v10_cmip5{2}; 

%%	calculate multiplicative factor
%	get number of models and months ::
NUMDATA = size(data{1}{1, 1}, 3); 
NUMMOD = size(data{1}, 2); 
NUMAGE = size(data, 2);

%	preallocate space ::
factor_lgm_pic_cmip5 = cell([1, 2]); % 1 (u10), 2 (v10)

%	loop over all data, months, and models to calculate factor ::
%-  count data ::
count_data = 1; 

%- 	over all data ::
for iAge = 1 : 2 : NUMAGE

	%- 	make data ::
	pic_data = data{iAge};
	lgm_data = data{iAge + 1}; 

	%-	over all months ::
    for iMod = 1 : 1 : NUMMOD
	
		%- over all models ::
		for iData = 1 : 1 : NUMDATA
	
			%	get model data ::
			mod_pic = lgm_data{1, iMod}(:, :, iData); 
			mod_lgm	= pic_data{1, iMod}(:, :, iData); 

			%	calculate factor ::
			factor_lgm_pic_cmip5{count_data}{1, iMod}(:, :, iData) = mod_lgm ./ mod_pic;
	
		end
	
    end

    %-  interate data counter ::
    count_data = count_data + 1; 

end

%%	save data
save(fullfile(output_path, 'wind_factor', 'factor_lgm_pic_cmip5.mat'), 'factor_lgm_pic_cmip5', '-v7.3');

%%	end program