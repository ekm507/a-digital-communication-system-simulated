function outData = PSKangleDemod (phasors, M)

    q = size(phasors);
    q = q(2);

    demodulatedData = zeros(1, q);

    lastTheta = 0;
    for i = 1:q
        theta = angle(phasors(i));
        theta = mod(theta, 2 * pi);
        
        alpha = lastTheta - theta;
        alpha = mod(alpha, 2 * pi);

        norm_angle = alpha / ( 2 *pi ) * M;
        data = round(norm_angle);
        data = mod(4-data, 4);
        demodulatedData(i) = data;
        lastTheta = theta;
    end
    outData = demodulatedData;
end