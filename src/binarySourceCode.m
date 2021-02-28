function outData = binarySourceCode (fileName)

    fileID = fopen(fileName);
    fileBytes = fread(fileID);
    fclose(fileID);

    fileBytes = fileBytes.';

    outData = [];

    for byte = fileBytes
        
        numberBits = [];
        % convert byte to bits.
        for i = 1:8
            bit = mod(byte, 2);
            numberBits = [bit numberBits];
            byte = floor(byte/2);
        end

        outData = [outData numberBits];
    end

end