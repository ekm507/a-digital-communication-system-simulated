% this function does a differential decoding to data
% output data = f(data you want to decode, M (How big a number in data can be. output will be modulo to M))
function decodedData = diffDecode(inputData, M)


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % old way of doing this:

    % % some lazy kind of preallocating output data
    % diffDecoded_data = inputData;
    % 
    % % for each number in data do:
    % % get size of data.
    % K = size(diffDecoded_data);
    % 
    % % k(2) = size of data in numbers
    % K = K(2);
    % for i = 2:K
    %     % decode it differentially and add output to output data.
    %     % decoding is done by subtracting two last numbers.
    %     diffDecoded_data(i) = mod(inputData(i) - inputData(i-1) , M);
    % end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % new way! with more performance

    % input data with a zero added to the end to avoid size conflicts
    b = [inputData 0];

    % input data shifted by 1 with a zero added to begining to avoid losing data
    a = [0 inputData];

    % diff decoded data!
    decodedData = mod(a - b, 2);
    
end
