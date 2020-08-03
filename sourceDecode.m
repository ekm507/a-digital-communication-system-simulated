function outText = sourceDecode (inputData, numbersPerSymbol, M)

    q = size(inputData);
    q = q(2);

    outText = [];

    for i = 1:numbersPerSymbol:q-numbersPerSymbol

        block = inputData(i:i+numbersPerSymbol-1);
        character = 0;

        for j = block(end:-1:1)

            character = character * M + j;
        end

        outText = [outText (character)];

    end

    outText = char(outText);

end