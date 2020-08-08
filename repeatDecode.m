function outData = repeatDecode (inputData, repeatSize)

    q = length(inputData);
    newSize = q / repeatSize;
    temp = reshape(inputData, repeatSize, newSize);
    outData = round(mode(temp));

end