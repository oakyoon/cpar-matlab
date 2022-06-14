function X = randn_t95iw(varargin)
% RANDN_T95IW samples random values from the standard normal distribution with
%   its lower and upper tails truncated outside 95% interval width
%
% The input and output variables are the same as rand() function.
%
% See also RAND.

	X = norminv(rand(varargin{:}) * .95 + .025, 0, 1);
end