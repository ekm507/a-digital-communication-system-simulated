function diffCoded_data = diffCode(data, M)
    q = size(data);
    temp_out = zeros(q);
    q = q(2);

    last_num = 0;
    for i = 1:q
        last_num = mod(last_num + data(i), M);
        temp_out(i) = last_num;
    end
    diffCoded_data = temp_out;
end