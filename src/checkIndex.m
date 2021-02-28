% this function removes indices from blocks and returns them seperated from gross data.

% output is a cell.
% output(i, 1) will be index of i'th block.
% output(i, 2) will be gross data of i'th block.

% output = f(input data seperated in blocks, size of index bits)
function indexAndData = checkIndex (inputData, indexSize)

    % function output will be stored in this cell
    % which includes both index bits and data.
    indexAndData = {};

    % itterate over blocks in input data
    for block = inputData

        % convert block to matrix so we can do further calculations on it
        block = cell2mat(block);

        % index bits are initial bits of the block.
        % extract index bits from block
        indexBits = block(1:indexSize);

        % remaining bits in block are the pure bits.
        % extract gross bits from the block
        grossBits = block(indexSize + 1 : end);

        % add index bits and gross bits seperately to output cell.
        indexAndData = [indexAndData; {indexBits grossBits} ];

    % seperating index bits and gross data from data blocks done.
    end

end