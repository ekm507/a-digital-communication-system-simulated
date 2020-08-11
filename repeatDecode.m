% this function does the repeat decoding
% repeat coding is repeating each digit so it will be easier to extract main data.

% decoded data = f(data to decode, number of repetitions used in coding)
function outData = repeatDecode (inputData, repeatSize)

    %if there is even a need to decode
    if repeatSize > 1

        % get length of input data
        q = length(inputData);
        
        % calculate new size of the matrix
        newSize = floor(q / repeatSize);

        q1 = newSize * repeatSize;

        inputData = inputData(q - q1 + 1 : end);

        % reshape the vector to a 2D matrix, so that repetitions come along in a vector
        temp = reshape(inputData, repeatSize, newSize);

        % assume the true data is the data with most repetition.
        % so mod of each vector should be used/
        outData = mode(temp);

    % but if there is not a need to decode
    else

        % just return the input data
        outData = inputData;

    % checking for need of decoding done.
    end

end