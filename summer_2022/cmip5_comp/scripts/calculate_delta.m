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
data{1} = cmip5_u10_lgm_uvic_monthly;
data{2} = cmip5_u10_pic_uvic_monthly; 

%	v10 ::
data{3} = cmip5_v10_lgm_uvic_monthly; 
data{4} = cmip5_v10_pic_uvic_monthly; 

%%	calculate multiplicative factor
%	get number of models and months ::
NUMMOD = size(data{1}{1, 1}, 3); 
NUMMON = size(data{1}, 2); 
NUMDATA = size(data, 2);

%	preallocate space ::
factor_lgm_pic = cell(size(data{1})); 

%	loop over all data, months, and models to calculate factor ::
%- 	over all data ::
for iData = 1 : 2 : NUMDATA

	%- 	make data ::
	lgm_data = data{iData}; 
	pic_data = data{iData + 1};

	%-	over all months ::
	for iMon = 1 : 1 : NUMMON
	
		%- over all models ::
		for iMod = 1 : 1 : NUMMOD
	
			%	get model data ::
			mod_pic = lgm_data{1, iMon}(:, :, iMod); 
			mod_lgm	= pic_data{1, iMon}(:, :, iMod); 

			%	calculate factor ::
			factor_lgm_pic{1, iMon}(:, :, iMod) = mod_lgm ./ mod_pic;
	
		end
	
	end

end

%%	save data
save(fullfile(output_path, 'wind_factor', 'factor_lgm_pic.mat'), 'factor_lgm_pic');

%%	end program