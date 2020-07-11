function decodedData = diffDecode(inputData, M)

    diffDecoded_data = inputData;
    K = size(diffDecoded_data);
    K = K(2);

    for i = 2:K
        diffDecoded_data(i) = mod(inputData(i) - inputData(i-1) , M);
    end

    decodedData = diffDecoded_data;
end
