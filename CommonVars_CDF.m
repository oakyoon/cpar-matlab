%
% Common variables used for model fitting.
%

% CDF function for model fitting. We used a lognormal CDF as an underlying,
% non-rhythmic CDF. For this particular [cdfFun], [B] should be a vector with
% 3 elements: the expected value μ of a lognrmal distribution, the SD σ of a
% lognormal distribution, and the delay parameter d.
cdfFun = @(B, x) logncdf(x - B(3), B(1), B(2));

% Sets of initial guesses for the three parameters of the lognormal CDF. Each
% row of [cdfB0] is a set of initial guesses. This particular set was determined
% to provide reasonable initial guesses for the data used in Examples 1-3. You
% will want to determine your own  sets of initial guesses that work best for
% your own data.
cdfB0  = combmat( ...
	[-2; -1.5; -1; -.5; 0], ...
	[.4; .6; .8; 1; 1.2], ...
	[.400; .600; .800]);

% Lower and upper bounds for the three parameters of the lognormal CDF. 
cdfBlb = [-100, .01, 0];
cdfBub = [ 100, 100, 5];

% Sets of initial guesses for the last two parameters of a rhythmic
% transformation function, phase p and amplitude k.
rhythmB0 = combmat( ...
	[-.75; -.25; .25; .75] * pi, ...
	[.1; .3; .5; .7; .9]);
