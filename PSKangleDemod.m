% demodulate PSK phasors into numbers.
% this works in a differential method.

% demodulated data = f(phasors out of PSK demodulator, M ( PSK modulation size) )
function outData = PSKangleDemod (phasors, M)

    % get number of phasors
    q = size(phasors);
    q = q(2);

    % demodulated data will be stored here.
    demodulatedData = zeros(1, q);

    % latest phasor.
    % since this is going to demodulate it differentially, latest phasor is also needed.
    lastTheta = 0;

    % itterate over all phasors.
    for i = 1:q

        % get angle of the phasor.
        theta = angle(phasors(i));
        % translate the angle between 0 and 2*π
        theta = mod(theta, 2 * pi);
        
        % subtract last two angles.
        % differetion happens here!
        alpha = lastTheta - theta;
        % translate subtracted angle to [0 ~ 2π]
        alpha = mod(alpha, 2 * pi);


        % map subtracted angle. from [0 ~ π] to [0 ~ M]  (M is the max number of modulation possible)
        norm_angle = alpha / ( 2 *pi ) * M;

        % find the nearest number to it. which is most likely to be the Original number.
        data = round(norm_angle);

        % seems like we need to reverse it!
        data = mod(M-data, M);
        % now the number is found!

        % add the found number to list
        demodulatedData(i) = data;

        % update the latest phasor. as mentioned, this is a differential demodulation and we need latest phasor anyway.
        lastTheta = theta;
    
    % differential demodulation done!
    end

    % return list of found numbers as output data
    outData = demodulatedData;

end