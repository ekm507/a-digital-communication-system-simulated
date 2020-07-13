function parityAddedData = parityAdd(data, ParityBlockSize, M)

    q = size(data);
    q = q(2);
    temp_output = [];
    for i = 1 : ParityBlockSize : q - ParityBlockSize  +1
        b = data(i : i + ParityBlockSize - 1);
        c = mod(sum(b), M);
        temp_output = [temp_output b c];
    end

    parityAddedData = temp_output;
end
