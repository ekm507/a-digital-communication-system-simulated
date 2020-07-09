function [signalOut, carrier] = modulatePSK (data, M, signalLength, sampling_frequency, carrier_frequency)
    
    % prepare coefficients for modulation
    txSig = pskmod(data,M,pi);

    % trying to create a carrier signal.
    % time domain. 
    T = 0:1/sampling_frequency:signalLength;
    % one carrier signal
    carrier = sin(carrier_frequency * 2*pi *T);


    % transmitter's output signal. which is in the ideal form
    outputSignal = 0;
    q = size(data);
    q = q(2);

    for i = 1:q
        temp = carrier * txSig(i);
        outputSignal = [outputSignal,temp];
    end
    outputSignal = real(outputSignal);
    signalOut = outputSignal;

end
