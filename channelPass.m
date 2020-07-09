function outputSignal = channelPass(inputSignal, SNR, shiftSize)
    noisySignal = awgn(inputSignal, SNR);
    if shiftSize > 0
        shiftedSignal = noisySignal(shiftSize + 1 : end);
    else
        initialSignal = awgn(zeros([1 -shiftSize]), 10);
        shiftedSignal = [initialSignal noisySignal];
    end
    outputSignal = shiftedSignal;
end
