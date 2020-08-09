function outData = repeatDecode (inputData, repeatSize)

    if repeatSize > 1
        q = length(inputData);
        newSize = q / repeatSize;
        temp = reshape(inputData, repeatSize, newSize);
        outData = round(mode(temp));
    else
        outData = inputData;
    end

end