function diffCoded_data = diffCode(data)
    last_bit = 0;
    q = size(data);
    temp_out = zeros(q);
    q = q(2);

    for i = 1:q
        if data(i) == 1
            last_bit = 1 - last_bit;
        end
        temp_out(i) = last_bit;
    end
    diffCoded_data = temp_out;
end