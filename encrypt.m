function outData = encrypt (inputData, keys, blockSize, M)

    q = length(inputData);
    numberOfBlocks = floor(q/blockSize);
    qMax = numberOfBlocks * blockSize;

    data = reshape(inputData, blockSize, numberOfBlocks);
    data = data.';

    outData = [];

    for i = 1:numberOfBlocks
        block = data(i, : );
        key = keys(i, :);
        [tmpOut, carryOut] = sumMatrix(block, key, M, 0);
        outData = [outData tmpOut];
    end


end