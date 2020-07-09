function decodedData = diffDecode(inputData)

    diffDecoded_data = inputData;
    last = 0;
    K = size(diffDecoded_data);
    K = K(2);
    for i = 2:K
        if inputData(i) == inputData(i - 1)
            diffDecoded_data(i) = 0;
        else
            diffDecoded_data(i) = 1;
        end
    end

    decodedData = diffDecoded_data;
end
