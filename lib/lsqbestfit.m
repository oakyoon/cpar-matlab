function varargout = lsqbestfit(fun, B0, xdata, ydata, lb, ub, opts)
% LSQBESTFIT runs lsqcurvefit() multiple times, each time with a different set
%   of initial guesses and returns output variables from the best fit
%
% For the input and output variables, please refer to the help document for 
% lsqcurvefit(FUN, X0, XDATA, YDATA, LB, UB, OPTIONS). The only difference
% between the lsqbestfit() function and the lsqcurvefit() function is the second
% input variable [B0]: lsqbestfit() function allows multiple rows for different
% sets of initial guesses.
%
% See also LSQCURVEFIT.

	n_fits  = size(B0, 1);
	argouts = cell(n_fits, max(nargout, 2));

	for f = 1:n_fits
		[argouts{f, :}] = lsqcurvefit(fun, B0(f, :), xdata, ydata, lb, ub, opts);
	end
	[~, best_fit] = min(cell2mat(argouts(:, 2)));
	varargout = argouts(best_fit, 1:nargout);
end