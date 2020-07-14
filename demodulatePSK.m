function outputPhasors = demodulatePSK(inputSignal, M, signalLength, sampling_frequency, carrier_frequency)

    output_dem = [];

    T = 0:1/sampling_frequency:signalLength;
    carrierS = sin(carrier_frequency * 2*pi *T);
    carrierC = sin(carrier_frequency * 2*pi *T + pi/2);

    q = size(T);
    q = q(2);

    output_dem = zeros(1, floor(length(inputSignal) / q) +1);

    % Demodulation process starts
    for k = 1:q:length(inputSignal)
        if k+q-1 > length(inputSignal)
            break;
        end
        signalBlock = inputSignal(k:k+q-1);
        Multiplied_SignalS = 0;
        Multiplied_SignalC = 0;
        
        Multiplied_SignalS = mean(signalBlock .* carrierS);
        Multiplied_SignalC = mean(signalBlock .* carrierC);
        
        phasor = (Multiplied_SignalS + Multiplied_SignalC * (0+1i));
        output_dem(floor(k/q)+1) = phasor;
    end
    %scatterplot(output_dem)

    outputPhasors = output_dem;

end
