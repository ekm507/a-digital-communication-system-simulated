% pass signal through channel.

% for now, channel will add noise and shift signal.
% output signal = f(signal to pass through channel, Signal to Noise Ratio, size of shift in signal in samples)

function outputSignal = channelPass(inputSignal, SNR, shiftSize)
    % add noise to the signal.
    noisySignal = awgn(inputSignal, SNR);

    % if you are going to miss initial samples of signal
    if shiftSize > 0
        % shift signal to the left
        shiftedSignal = noisySignal(shiftSize + 1 : end);
    
    % or if you are receiving the signal with a delay
    else
        % generate empty signal with added noise
        initialSignal = awgn(zeros([1 -shiftSize]), 10);

        % shift the signal to the right
        shiftedSignal = [initialSignal noisySignal];
    end

    % output will be the shifted signal
    outputSignal = shiftedSignal;
end
