function outputData = demodulatePSK(inputSignal, M, signalLength, sampling_frequency, carrier_frequency)

    output_dem = [];

    T = 0:1/sampling_frequency:signalLength;
    carrierS = sin(carrier_frequency * 2*pi *T);
    carrierC = sin(carrier_frequency * 2*pi *T + pi/2);

    q = size(T);
    q = q(2);

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
        
        output_dem = [output_dem,(Multiplied_SignalS + Multiplied_SignalC * (0+1i))];    
    end
    %scatterplot(output_dem)

    k = [];
    lastTheta = 0;
    for i = output_dem
        theta = angle(i);
        theta = mod(theta, 2 * pi);
        alpha = lastTheta - theta;
        alpha = mod(alpha, 2 * pi);
        norm_angle = alpha / ( 2 *pi ) * M;
        data = round(norm_angle);
        data = mod(4-data, 4);
        k = [k data];
        lastTheta = theta;

    end
    k
    outputData = pskdemod(output_dem, M);
    

end
