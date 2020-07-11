function parityAddedData = parityAdd(data, ParityBlockSize)

    q = size(data);
    q = q(2);
    temp_output = [];

    for i = [1 : ParityBlockSize : q - ParityBlockSize + 1]
        if i + ParityBlockSize - 1 > q
            break;
        end
        b = data(i : i + ParityBlockSize - 1);
        c = 0;
        for j = b
            c = xor(c,j);
        end
        temp_output = [temp_output b c];
    end

    parityAddedData = temp_output;
end
