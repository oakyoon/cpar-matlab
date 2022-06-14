function [fftAmp, pdfInfo, cdfB] = fftRhythms(pdfBin, pdfFun, fftWin, icdfFun, cdfFun, cdfB0, xData, cpData, cdfBlb, cdfBub, opts)
% fftRhythms conducts spectral analysis employed in Cha & Blake (2019)
%
% [fftAmp, pdfInfo, cdfB] = fftRhythms(pdfBin, pdfFun, fftWin, icdfFun,
%   cdfFun, cdfB0, xData, cpData, cdfBlb, cdfBub, opts)
%
% Input Variables:
%   pdfBin  - bin width of a probabilty density histogram (in seconds)
%   pdfFun  - PDF function; please refer to Step2B_FFTAmpRndWalkData.m
%   fftWin  - window size for FFT (in seconds)
%   icdfFun - inverse CDF function; this function should be the inverse function
%             of [cdfFun]; please refer to Step2B_FFTAmpRndWalkData.m
%   cdfFun - CDF function; this function should be the cumulative distribution
%            function of [pdfFun]; please refer to CommonVars_CDF.m
%   cdfB0  - matrix containing sets of initial guesses for CDF parameters; each
%            row is a set of initial guesses; please refer to CommonVars_CDF.m
%   xData  - duration data (in seconds), sorted in ascending order
%   cpData - cumulative probability values for each data point in [xData]
%   cdfBlb - lower bound for CDF parameters
%   cdfBub - upper bound for CDF parameters
%   opts   - this variable is passed to the lib/lsqbestfit() function, and then
%            to the lsqcurvefit() function
%
% Output Variables:
%   fftAmp  - spectral power distribution
%   pdfInfo - structure containing information about the FFT window
%   cdfB    - best-fit CDF parameters
%
% This function relies on Optimization Toolbox and the functions in the lib/
% directory. You may execute "addpath('lib');" to add the lib/ directory to
% MATLAB path.
%
% See also OPTIMOPTIONS

	% Step 1: find the best-fit CDF parameters.
	cdfB = lsqbestfit(cdfFun, cdfB0, xData, cpData, cdfBlb, cdfBub, opts);

	% Lower and upper bounds of the FFT window.
	wFFTlb = icdfFun(cdfB, .5) - (fftWin / 2);
	wFFTlb = max(wFFTlb, min(xData));
	wFFTub = wFFTlb + fftWin;

	% Bin edges for the probabilty density histogram.
	tEdgeLb = floor(min(xData) / pdfBin) * pdfBin;
	tEdgeUb = ceil(max(max(xData), wFFTub) / pdfBin) * pdfBin;
	tEdges  = tEdgeLb:pdfBin:tEdgeUb;
	tData   = tEdges(2:end) - (pdfBin / 2);

	% Step 2: build the probabilty density histogram, calculate residual
	% probabilty values, and then normalize the residual probabilty values.
	pRaw   = histcounts(xData, tEdges, 'Normalization', 'pdf');
	pResid = pRaw - pdfFun(cdfB, tData);
	pResid = pResid / (cdfFun(cdfB, wFFTub) - cdfFun(cdfB, wFFTlb));
	fftIdx = find(tEdges >= wFFTlb, 1) - 1 + (1:round(fftWin / pdfBin));

	% Output variable [pdfInfo].
	pdfInfo = struct( ...
		'tData',  tData, ...
		'tEdges', tEdges, ...
		'pRaw',   pRaw, ...
		'pResid', pResid, ...
		'fftIdx', fftIdx);

	% Step 3: conduct FFT and calculate the spectral power distribution.
	fftData = fft(pResid(fftIdx));
	fftHalf = round(length(fftIdx) * .5 + .5);
	fftAmp  = abs(fftData(2:fftHalf) / length(fftIdx)) * 2;
end