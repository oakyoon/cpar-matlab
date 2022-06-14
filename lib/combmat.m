function M = combmat(varargin)
% COMBMAT generates all possible combinations of concatenated rows, with each
%   row in a combination being a row of each input variable
%
% Examples:
%   combmat([1; 2], [1; 2; 3])  % returns [1 1; 1 2; 1 3; 2 1; 2 2; 2 3]
%   combmat([1, 2], [1; 2; 3])  % returns [1 2 1; 1 2 2; 1 2 3]

	if any(~cellfun(@isnumeric, varargin))
		error('All inputs must be numeric.');
	end

	ar = cellfun(@(a) size(a, 1), varargin);
	ac = cellfun(@(a) size(a, 2), varargin);

	M = zeros(prod(ar), sum(ac));
	for i = 1:nargin
		M(:, sum(ac(1:(i - 1))) + (1:ac(i))) = cell2mat(repmat( ...
			cellfun(@(m) repmat(m, prod(ar((i + 1):end)), 1), ...
				num2cell(varargin{i}, 2), 'UniformOutput', false), ...
			prod(ar(1:(i - 1))), 1));
	end
end