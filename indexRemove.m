% this function removes indices from blocks and returns them seperated from gross data.

% output is a cell.
% output(i, 1) will be index of i'th block.
% output(i, 2) will be gross data of i'th block.

% output = f(input data seperated in blocks, size of index bits)
function outData = indexRemove (inputData, indexBlockSize, indexSize)

    % function output will be stored in this cell
    outData = [];

    q = size(inputData);
    q = q(2);

    % itterate over blocks in input data
    for i = 1:indexBlockSize + indexSize:q
        if i + indexBlockSize + indexSize - 1 > q
            break
        end
        
        block = inputData(i : i+indexBlockSize + indexSize - 1);


        % index bits are initial bits of the block.
        % extract index bits from block
        indexBits = block(1:indexSize);

        % remaining bits in block are the pure bits.
        % extract gross bits from the block
        grossBits = block(indexSize + 1 : end);

        outData = [outData grossBits];
    % seperating index bits and gross data from data blocks done.
    end

end