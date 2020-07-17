% this function does a differential decoding to data
% output data = f(data you want to decode, M (How big a number in data can be. output will be modulo to M))
function decodedData = diffDecode(inputData, M)

    % some lazy kind of preallocating output data
    diffDecoded_data = inputData;

    % get size of data.
    K = size(diffDecoded_data);
    % k(2) = size of data in numbers
    K = K(2);

    % for each number in data do:
    for i = 2:K
        % decode it differentially and add output to output data.
        % decoding is done by subtracting two last numbers.
        diffDecoded_data(i) = mod(inputData(i) - inputData(i-1) , M);
    end

    %
    decodedData = diffDecoded_data;
end
