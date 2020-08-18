% Demodulate Signal that is Modulated with MPSK method.
% output phasors(angles) = f(input signal, Modulation level, length of one pulse, sampling frequency of digital signal, frequency of carrier pulses)

function outputPhasors = demodulateBPSK_nodiff(inputSignal, M, signalLength, sampling_frequency, carrier_frequency)

    % get size of input signal
    q0 = size(inputSignal);
    q0 = q0(2);

    % generate sin and cos signals (carrier signals) with size of input signal.
    % TODO: simulate some imperfections
    
    % generate time domain
    T = 0:1/sampling_frequency:q0/sampling_frequency - 1/sampling_frequency;

    % carrier with phase = 0
    carrierS = sin(carrier_frequency * 2*pi *T);

    % carrier with phase = π
    carrierC = sin(carrier_frequency * 2*pi *T + pi/2);
    
    % multiply signal by carriers.
    
    % signal multiplied by carrier with phase = 0
    sigS = inputSignal .* carrierS;

    % signal multiplied by carrier with phase = π
    sigC = inputSignal .* carrierC;

    % output phasors will be stored here
    output_dem = zeros(1, floor(length(inputSignal) / q0) +1);

    % get size of each signal block. (size of each pulse in samples)
    q = signalLength * sampling_frequency + 1;

    % get number of pulses in signal.
    n = q0 / q;

    n = floor(n);

    newSize = q * n;

    % seperate sine multiplied signal into pulses
    Blocks_of_sigS = reshape(sigS(1:q*n), q, n);

    % seperate cosine multiplied signal into pulses
    Blocks_of_sigC = reshape(sigC(1:q*n), q, n);

    % get mean of each signal block. mean works like integral.
    % having these 2 means, we can calculate PSK phasors for each pulse
    pS = mean(Blocks_of_sigS);
    pC = mean(Blocks_of_sigC);
    
    
    % output all phasors
    outputPhasors = pS + pC * (0 + 1i);

end
