% this function gets some bits and decodes that to numbers.
% then re-encodes the numbers to text characters.

% output text = f(data to convert to text, number of 
% symbols denoting a number(source block size), M(modulation size))
function outText = sourceDecode (inputData, numbersPerSymbol, M)

    % get size of input data
    q = size(inputData);
    q = q(2);

    % output of the function will be stored here
    outText = [];

    %% itterate through data blocks in input data.
    % each block represents a number
    % and a number represents a text character in ascii
    for i = 1:numbersPerSymbol:q-numbersPerSymbol + 1

        % get a block of numbers to convert it.
        block = inputData(i:i+numbersPerSymbol-1);

        % convert data from base M to a single number.

        % decoded number of the block will be stored here.
        character = 0;

        % itterate through bits in data block
        for j = block(end:-1:1)
        % for each bit in data block do

            % add the bit to the number for converting from base M to plain number
            character = character * M + j;
        
        % decoding block done
        end

        % add decoded number to list
        outText = [outText (character)];

    % decoding all data into numbers done
    end

    % now the numbers should be re-encoded by ascii coding
    % because we want some text, not some numbers
    % encode output numbers to ascii
    outText = char(outText);

end