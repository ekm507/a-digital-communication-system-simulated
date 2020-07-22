% this function modulates input data in MPSK modulation.

% modulated signal = f(input data, Modulation size, length of each pulse(by seconds),
%   sampling frequency(by Hertz), frequency of the MPSK carrier signal(By Hertz))

function [signalOut] = modulatePSK (data, M, signalLength, sampling_frequency, carrier_frequency)
    
    % prepare coefficients for modulation

    % trying to create a carrier signal.
    % time domain.
    T = 0:1/sampling_frequency:signalLength;

    % one carrier signal
    
    % size of signal in samples
    k = size(T);
    k = k(2);

    % for M-PSK there will be M carrier signals. each with 2π/M phase difference.

    % preallocate carriers.
    carrier = zeros(M,k);

    % for each demanded phase, do:
    for i = 1:M
        % generate a sinusoidal carrier with initial phase for itself.
        carrier(i, :) = sin(carrier_frequency * 2*pi *T + (i-1)/M*2*pi);
    end


    % transmitter's output signal. which is in the ideal form
    q = size(data);
    q = q(2);

    % preallocate output signal.
    outputSignal = zeros(1, k * q);

    % for each number in data do:
    for i = 1:q
        % select carrier special for the number.
        temp = carrier(data(i) + 1, :);

        % add it to output signal. so it will be generated one by one.
        outputSignal((i-1) * k + 1 : i * k) = temp;
    end

    % return output signal
    signalOut = outputSignal;

end
