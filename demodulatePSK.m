function outputData = demodulatePSK(inputSignal, carrier)

    T = size(carrier);
    T = T(2);
    output_dem = [];

    % Initial Clock Pulse Synchronization
    % find the point within a signal size where multiplication output is maximum
    c = [];
    for ii = 1:T
    b = inputSignal(ii:ii+T-1);
    c(ii) = abs(mean(b .* carrier));
    end
    [M, ii] = max(c);
    % shift the signal
    inputSignal = inputSignal(ii:end);

    % Demodulation process starts
    for k = 1:T:length(inputSignal)
        if k+T-1 > length(inputSignal)
            break;
        end
        signalBlock = inputSignal(k:k+T-1);
        Multiplied_Signal = 0;
        
        Multiplied_Signal = signalBlock .* carrier;
        if mean(Multiplied_Signal) >= 0
            finded = 1;
        else 
            finded = 0;
        end
        output_dem = [output_dem,finded];    
    end
    outputData = output_dem;

end
