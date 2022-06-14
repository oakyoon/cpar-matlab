function rx = rhythmconv(x, F, p, k)
% RHYTHMCONV implements rhythmic transformation function
%
% rx = RHYTHMCONV(x, F, p, k)
%
% Input Variables:
%   x - data to transform
%   F - frequency of rhythmic transformation (in Hz)
%   p - phase of rhythmic transformation (in radians)
%   k - amplitude of rhythmic transformation (0 ~ 1)
%
% Output Variable:
%   rx - transformed data

	if nargin == 2
		k = F(3);
		p = F(2);
		F = F(1);
	elseif nargin < 4
		error('Not enough input arguments.');
	elseif nargin > 4
		error('Too many input arguments.');
	end

	cx = cos(x * 2 * pi * F - p) - 1;
	rx = x - k * cx / (2 * pi * F);
end