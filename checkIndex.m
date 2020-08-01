function indexAndData = checkIndex (inputData, indexSize, M)

    indexAndData = {};
    for block = inputData
        block = cell2mat(block);
        indexBits = block(1:indexSize);
        grossBits = block(indexSize + 1 : end);

        indexAndData = [indexAndData; {indexBits grossBits} ];
    end

end