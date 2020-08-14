% this function does the one-time-pad decryption.
% but uses index numbers to fix problems.

function outData = decryptWithIndex (inputData, keys, cryptBlockSize, M)

    outData = [];

    q = size(inputData);

    for i = 1:q(1)

        blockData = cell2mat(inputData(i, 1));
        blockIndex = cell2mat(inputData(i, 2));

        indexNumber = matrix2number(blockIndex, M);

        key = keys(indexNumber * cryptBlockSize + 1: (indexNumber + 1) * cryptBlockSize);


    
        % for decrypting, key should be subtracted from data block.
        % to do subtraction, we can add n'th compliment
        % calculate n'th complimentof key
        key_comp = complimentMatrix(key, M);

        % sum up n'th compliment of the key with data block
        % (subtract key from data block)
        [tmpOut, carryOut] = sumMatrix(blockData, key_comp, M, 0);

        % add decrypted data block to output data
        outData = [outData tmpOut];


    end

end