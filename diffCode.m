% this function does a differential coding to data
% output data = f(data you want to encode, M (How big a number in data can be. output will be modulo to M))
function diffCoded_data = diffCode(data, M)

    % get size of data. 
    q = size(data);

    % preallocate output data.
    temp_out = zeros(q);

    % so q(2) will be size of data
    q = q(2);

    % latest number added to output data
    last_num = 0;

    % itterate over 1 to size of input data
    for i = 1:q
        % generate differential coded number.
        % it will be sum of latest added number and new number. modulo by M
        last_num = mod(last_num + data(i), M);

        % add diff coded number to output data
        temp_out(i) = last_num;
    end

    % return output data
    diffCoded_data = temp_out;
end