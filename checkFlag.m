% output data = f(data to find the flag in and remove added numbers from, size of blocks with flag added at the begining or end of each,
% size of flag )

function outputData = checkFlag (inputData, flagSize)
    
    outputData = [];
    
    numberOfOnes = 0;

    % first find a flag.

    q = size(inputData);
    q = q(2);

    % itterate over bits in input data
    for b = 1:q

        % if the bit was a 1
        if inputData(b) == 1
            % add ones counter by 1
            numberOfOnes = numberOfOnes + 1;
        % but if it was other than 1
        else
            % reset the ones counter
            numberOfOnes = 0;
        % counting number of ones done.
        end

        % if a flag is found
        if numberOfOnes >= flagSize
            % cut data from there and them start cleaning it
            inputData = inputData(b + 2:end);

            % flag is found. no need to continue itterating.
            break
        % checking for if there is a flag is done.
        end
    % flag is found and data is cut
    end


    % start cleaning data

    q = size(inputData);
    q = q(2)

    buffer = [];

    % itterate over bits in data (that is cut)
    for b = 1:q
        
        buffer = [buffer inputData(b)];
        
        % so if bit was a 1
        if inputData(b) == 1
            % add ones counter by 1
            numberOfOnes = numberOfOnes + 1;
        end

        if numberOfOnes ==flagSize - 1
            if inputData(b + 1) == 1
                
            end
        end
        
    end
end