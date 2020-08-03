function outData = sourceCode (inputText, numbersPerSymbol, M)

    outData = [];
    for character = inputText
        asciiChar = double(character);
        for i = 1:numbersPerSymbol
            bit = mod(asciiChar, M);
            asciiChar = floor(asciiChar / M);
            outData = [outData bit];
        end


    end

end