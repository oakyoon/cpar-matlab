function X = randn_tlt0(varargin)
% RANDN_TLT0 samples random values from a normal distribution with its lower
%   tail truncated at 0
%
% X = RANDN_TLT0(..., mu, sigma)
%
% Input Variable:
%   ...   - all input variables except the last two are passed directly to the
%           rand() function
%   mu    - mean of a normal distribution
%   sigma - standard deviation of a normal distribution
%
% Output Variables:
%   X - sampled random values
%
% See also RAND.

	mu    = varargin{end - 1};
	sigma = varargin{end};
	base  = normcdf(-mu / sigma);
	X = norminv(rand(varargin{1:(end - 2)}) * (1 - base) + base, 0, 1) * sigma + mu;
end