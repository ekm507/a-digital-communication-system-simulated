function outputData = parityCheck (inputData, ParityBlockSize)

    ParityCheckedData = [];
    q = size(inputData);
    q = q(2);

    for i = [1 : ParityBlockSize + 1 : q - ParityBlockSize + 2]

        if i + ParityBlockSize > q
            break;
        end

        b = inputData(i : i + ParityBlockSize - 1);
        c = 0;
        for j = b
            c = xor(c,j);
        end

        if c != inputData(i + ParityBlockSize)
            disp(i);
        end
        ParityCheckedData = [ParityCheckedData b];
    end

    outputData = ParityCheckedData;
end
