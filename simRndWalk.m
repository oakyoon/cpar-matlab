function rtMsec = simRndWalk(numTrials, timeoutMsec, dritfMean, driftSD, noiseSD, rhythmF, rhythmP, rhythmK)
% simRndWalk generates response times using modified random walk model
%   simulations, with an oscillation embedded in the drift rate
%
% rtMsec = simRndWalk(numTrials, timeoutMsec, dritfMean, driftSD, noiseSD,
%   rhythmF, rhythmP, rhythmK)
%
% Input Variables:
%   numTrials   - number of trials to simulate
%   timeoutMsec - maximum response time (in msec); if the model does not reach
%                 a decision until [timeoutMsec], response time for the trial
%                 will be set to NaN
%   dritfMean - mean drift rate
%   driftSD   - SD of drift rate across trials
%   noiseSD   - SD of noise at each tick
%   rhythmF   - frequency of the embedded oscillation (in Hz)
%   rhythmP   - phase of the embedded oscillation (in radians)
%   rhythmK   - amplitude of the embedded oscillation (0 ~ 1)
%
% Output Variable:
%   rtMsec - simulated response times (in msec)

	% Ticks in msec.
	tickSec     = (1:timeoutMsec) / 1000;
	% Sample drift rates for each trial, and modulate them with a sine function.
	driftRate   = randn_tlt0(numTrials, 1, dritfMean, driftSD);
	driftRhythm = sin(tickSec * 2 * pi * rhythmF - rhythmP) * rhythmK + 1;
	drift = bsxfun(@times, driftRate, driftRhythm);
	% Sample noises for each tick in every trial.
	noise = randn_tlt0(numTrials, timeoutMsec, 0, noiseSD);
	% Accumulate signal and noise for each trial (rows: trials, columns: ticks).
	cumEvdience = cumsum(drift + noise, 2);

	rtMsec = zeros(1, numTrials);
	% For each trial (each row in [cumEvdience]):
	for t = 1:numTrials
		% Determine response time.
		respTick = find(cumEvdience(t, :) > 1000, 1);
		if isempty (respTick)
			rtMsec(t) = nan;
		else
			rtMsec(t) = respTick;
		end
	end
end