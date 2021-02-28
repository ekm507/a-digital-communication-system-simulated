function binarySourceDecode (inputData, outputFileName)

    bytesToWrite = [];

    numberOfBytes = length(inputData) / 8;
    if numberOfBytes ~= floor(numberOfBytes)
        error('some bits seem to be missing.');
    end

    bitsMatrix = reshape(inputData, 8, numberOfBytes);

    %bitsMatrix = bitsMatrix.';

    for block = bitsMatrix

        block = block.';

        number = 0;

        for bit = block
            number = number * 2 + bit;
        end
        bytesToWrite = [bytesToWrite; number];
    end

    fileID = fopen(outputFileName, 'w');
    fwrite(fileID, bytesToWrite);
    fclose(fileID);

end