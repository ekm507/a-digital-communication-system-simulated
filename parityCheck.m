function outputData = parityCheck (inputData, ParityBlockSize, M)

    ParityCheckedData = [];
    q = size(inputData);
    q = q(2);

    a = mod(q + 1 - 1, ParityBlockSize + 1);
    max_decodable = q - ParityBlockSize  - a;

    for i = 1 : ParityBlockSize + 1 : max_decodable
        b = inputData(i : i + ParityBlockSize - 1);
        c = mod(sum(b), M);
        if c ~= inputData(i + ParityBlockSize)
        %    disp(i);
        end
        ParityCheckedData = [ParityCheckedData b];
    end

    outputData = ParityCheckedData;
end
