% This function checks recognizable flags in data and removes them.
% flags are added by addFlag function.
% flags are like this: 0 1 1 1 ... 1 1 0
% ( a sequence of ones by one zero at each side of sequence)
% lets call number of Ones in data as "flagSize"
% to avoid similarities, the bit after a sequence in data with (flegSize - 1) number of Ones, is not added to output data directly,
% but a zero is added before that.


% output data = f(data to find the flag in and remove added numbers from, size of blocks with flag added at the begining or end of each,
% size of flag )

function outputData = checkFlag (inputData, flagSize)
    
    % output data will be stored here
    outputData = [];
    

    % first find a flag.
    % then remove any data before that flag. ( and flag itself)

    % get size of the data
    q = size(inputData);
    q = q(2);


    % number of cascaded 1s seen.
    numberOfOnes = 0;

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

    % seperating data in blocks

    % data blocks with removed flag will be stored in this matrix
    % like this:
    %[ data block 1; data block 2; ...]
    FlagCheckedData = [];

    % get size of data with initial flag found and anything before that removed.
    q = size(inputData);
    q = q(2);

    % while there is still data unchecked
    while q > 1

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

                % add data block to matrix
                FlagCheckedData = [FlagCheckedData; inputData(1: b - flagSize)];
            
                % cut data from there and them start cleaning it
                inputData = inputData(b + 2:end);

                % flag is found. no need to continue itterating.
                break
            % checking for if there is a flag is done.
            end

        % flag is found. block is added. and data is cut
        end

        % get new size of data. because initial part of it is cleaned now.
        q = size(inputData);
        q = q(2);
    
    % separating data in blocks done.
    end



    % start cleaning data

    % itterate over the blocks.
    for k = FlagCheckedData
    % for each block do:
        
        buffer = k(1:flagSize + 1);
        
        % get size of a block
        q = size(k);
        q = q(2);

        % itterate over numbers in a block
        for b = 1:q


            % so if bit was a 1
            if inputData(b) == 1
                % add ones counter by 1
                numberOfOnes = numberOfOnes + 1;
            end

            if numberOfOnes ==flagSize - 1
                if inputData(b + 1) == 1
                    
                end
            end

        % cleaning this data block done
        end
    
    % cleaning all data blocks done
    end

% checking flags and cleaning data done.
end
