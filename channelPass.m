% pass signal through channel.

% for now, channel will add noise and shift signal.
% output signal = f(signal to pass through channel, Signal to Noise Ratio, size of shift in signal in samples)

function outputSignal = channelPass(inputSignal, SNR, shiftSize, channelFilterb, channelFiltera)
    
    filteredInputSignal = filter(channelFilterb, channelFiltera, inputSignal);

    % add noise to the signal.
    noisySignal = awgn(filteredInputSignal, SNR);

    % if you are going to miss initial samples of signal
    if shiftSize > 0
        % shift signal to the left
        shiftedSignal = noisySignal(shiftSize + 1 : end);
    
    % or if you are receiving the signal with a delay
    elseif shiftSize < 0
        % generate empty signal with added noise
        initialSignal = zeros(1, -shiftSize);
        initialSignal = awgn(initialSignal, SNR);

        % shift the signal to the right
        shiftedSignal = [initialSignal noisySignal];
    else
        shiftedSignal = noisySignal;
    end

    filteredOutputSignal = filter(channelFilterb, channelFiltera, shiftedSignal);

    % output will be the shifted signal
    outputSignal = filteredOutputSignal;
end
