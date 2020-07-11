function [signalOut] = modulatePSK (data, M, signalLength, sampling_frequency, carrier_frequency)
    
    % prepare coefficients for modulation

    % trying to create a carrier signal.
    % time domain. 
    T = 0:1/sampling_frequency:signalLength;
    % one carrier signal
    k = size(T);
    k = k(2);
    carrier = zeros(M,k);
    for i = 1:M
        carrier(i, :) = sin(carrier_frequency * 2*pi *T + (i-1)/M*2*pi);
    end


    % transmitter's output signal. which is in the ideal form
    outputSignal = 0;
    q = size(data);
    q = q(2);
    for i = 1:q
        temp = carrier(data(i) + 1, :);
        outputSignal = [outputSignal,temp];
    end
    signalOut = outputSignal;

end
