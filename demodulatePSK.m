% Demodulate Signal that is Modulated with MPSK method.
% output phasors(angles) = f(input signal, Modulation level, length of one pulse, sampling frequency of digital signal, frequency of carrier pulses)

function outputPhasors = demodulatePSK(inputSignal, M, signalLength, sampling_frequency, carrier_frequency)

    q = size(inputSignal);
    q = q(2);

    % generate sin and cos signals (carrier signals) with size of input signal.
    % TODO: simulate some imperfections
    
    % generate time domain
    T = 0:1/sampling_frequency:q/sampling_frequency - 1/sampling_frequency;

    % carrier with phase = 0
    carrierS = sin(carrier_frequency * 2*pi *T);

    % carrier with phase = pi
    carrierC = sin(carrier_frequency * 2*pi *T + pi/2);
    
    % multiply signal by carriers.
    
    % signal multiplied by carrier with phase = 0
    sigS = inputSignal .* carrierS;

    % signal multiplied by carrier with phase = pi
    sigC = inputSignal .* carrierC;

    % output phasors will be stored here
    output_dem = zeros(1, floor(length(inputSignal) / q) +1);

    q = signalLength * sampling_frequency;
    
    % Demodulation process starts
    for k = 1:q:length(inputSignal)
        if k+q-1 > length(inputSignal)
            break;
        end

        % get integral of each block of multiplied signals.

        % mean of each block multiplied by carrier with phase = 0
        Multiplied_SignalS = mean(sigS(k:k+q-1));

        % mean of each block multiplied by carrier with phase = pi
        Multiplied_SignalC = mean(sigC(k:k+q-1));
        
        % convert two numbers to a phasor
        phasor = (Multiplied_SignalS + Multiplied_SignalC * (0+1i));

        % add phasor to the list
        output_dem(floor(k/q)+1) = phasor;
    end
    %scatterplot(output_dem)

    % output all phasors
    outputPhasors = output_dem;
end
