% this function decrypts data using one-time-pad cryptography
% for doing this, you should provide one-time-pad keys.
% the same keys should be used for both encryption and decryption.

% decrypted data = f(data to decrypt, one-time-pad keys, cryptography block size, M)
function outData = decrypt (inputData, keys, blockSize, M)

    % get length of input data
    q = length(inputData);

    % calculate number of blocks
    numberOfBlocks = floor(q/blockSize);

    % next line is for avoiding errors when
    % data has extras that cant be reshaped properly
    qMax = numberOfBlocks * blockSize;

    inputData = inputData(1:qMax);

    % reshape data in blocks
    data = reshape(inputData, blockSize, numberOfBlocks);
    data = data.';

    % output data will be stored here
    outData = [];
    
    % for each block in data do
    for i = 1:numberOfBlocks

        % get data block
        block = data(i, : );

        % get the key
        key = keys(i, :);

        % for decrypting, key should be subtracted from data block.
        % to do subtraction, we can add n'th compliment
        % calculate n'th complimentof key
        key_comp = complimentMatrix(key, M);

        % sum up n'th compliment of the key with data block
        % (subtract key from data block)
        [tmpOut, carryOut] = sumMatrix(block, key_comp, M, 0);

        % add decrypted data block to output data
        outData = [outData tmpOut];

    % decrypting each block of data is done
    end

end