% this function gets some text as input and encodes that as
% some numbers, so that can be processed in other blocks in the system.

% output bits = f(text to encode, number of bits needed to encode
% each symbol in(source block size), M (modulation size)) 
function outData = sourceCode (inputText, numbersPerSymbol, M)

    % output data will be stored here
    outData = [];

    % itterate through characters in the text
    for character = inputText
    % for each character do:

        % decode it to number.
        % (decode ascii)
        asciiChar = double(character);

        % convert the number to base of M

        % we need a fixed size of bits.
        for i = 1:numbersPerSymbol

            % get modulo of number by M.
            bit = mod(asciiChar, M);

            % add modulo of number by M to output data vector.
            outData = [outData bit];

            % divide the number by M.
            asciiChar = floor(asciiChar / M);

        % converting number to base M and adding bits to output natrix done.
        end

    % encoding each character in the text done
    end

end