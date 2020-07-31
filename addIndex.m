function outputData = addIndex (inputData, blockSize, indexSize, M)
    outputData = [];
    q = size(inputData);
    q = q(2);

    indexBits = zeros(1, indexSize);
    sumBits = [zeros(1, indexSize - 1) 1];
    sumBits = 1;

    q = floor(q / blockSize) * blockSize;

    for i = 1:blockSize:q
        outputData = [outputData inputData(i:i+blockSize-1) indexBits];
        % increase index bits by 1
        % withdraw the carry
        [indexBits,_] = sumMatrix(indexBits, sumBits, M, 0);
    end

end