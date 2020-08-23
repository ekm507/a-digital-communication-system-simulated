% this function encrypts data using one-time-pad cryptography
% for doing this, you should provide one-time-pad keys.
% the same keys should be used for both encryption and decryption.

% encrypted data = f(data to encrypt, one-time-pad keys, cryptography block size, M)
function outData = encrypt (inputData, keys, blockSize, M)

    % get length of input data
    q = length(inputData);

    % calculate number of blocks
    numberOfBlocks = floor(q/blockSize);

    % next line is for avoiding errors when
    % data has extras that cant be reshaped properly
    qMax = numberOfBlocks * blockSize;

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

        % calculate sum of data block and key.
        [tmpOut, carryOut] = sumMatrix(block, key, M, 0);

        % add encrypted data block to output
        outData = [outData tmpOut];
    
    % encrypting each data block is done
    end


end