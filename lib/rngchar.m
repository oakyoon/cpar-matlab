function rngchar(S)
% RNGCHAR sets a random seed generated from a 4-character string
%
% Input Variable:
%   S - 4-character string for a random seed

	if ~ischar(S) || ~isvector(S) || (length(S) ~= 4)
		error('The seed must be a 4-character vector.');
	end

	rng('default');
	rng(typecast(uint8(S), 'uint32'), 'twister');
end