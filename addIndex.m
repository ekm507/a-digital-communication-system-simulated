% this function adds indices for blocks.

% data with indices added to each block of it = f(data to add block indices to it, size of blocks to add indices for each,
% size of each index matrix, M (modulation size - data numbers base))

function outputData = addIndex (inputData, blockSize, indexSize, M)

    % data with addded indices will be stored here
    outputData = [];

    % size of input data
    q = size(inputData);
    q = q(2);

    % index bits are like a number in base of M with each digit of it seperated in matrix elements.
    % so first index will be like:
    % [0 0 0 ... 0]
    % index bits will be stored here
    indexBits = zeros(1, indexSize);

    % at each block, index bits should be increased by a number.
    % best to use 1
    % so index bits will be summed up with this variable each time
    sumBits = 1;

    
    q0 = floor(q / blockSize) * blockSize;

    % itterate over blocks in data
    for i = 1:blockSize:q0

        % add index to the block.
        outputData = [outputData indexBits inputData(i:i+blockSize-1) ];
        % increase index bits by 1
        % withdraw the carry
        % get new index bits.
        [indexBits,_] = sumMatrix(indexBits, sumBits, M, 0);

    %
    end

    if q0 < q
        outputData = [outputData indexBits inputData(q0 + 1:end) ];
    end

    

end