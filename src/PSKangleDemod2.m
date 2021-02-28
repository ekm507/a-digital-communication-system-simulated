% demodulate PSK phasors into numbers.
% this works in a differential method.

% demodulated data = f(phasors out of PSK demodulator, M ( PSK modulation size) )
function outData = PSKangleDemod2 (phasors, M)

    % demodulated data will be stored here.

    angles = mod(angle(phasors), 2 * pi);

    a = [0 angles];
    b = [angles 0];
    c = mod(a - b, 2 * pi);
    d = c / (2*pi) * M;
    outData = round(d);

    % return list of found numbers as output data

end