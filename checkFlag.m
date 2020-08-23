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
    FlagCheckedData = {};

    % get size of data with initial flag found and anything before that removed.
    q = size(inputData);
    q = q(2);

    % latest size of data will be stored here. (at each level of cutting data.)
    lastq = q;

    % while there is still data unchecked
    while q > 1

        % number of cascaded ones seen.
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

                % add data block to matrix
                FlagCheckedData = [FlagCheckedData, inputData(1: b - flagSize-1)];

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

        % if no flag is found anymore, it means that we are at the end of the data.
        % if you are at the final block of the data
        if lastq == q

            % add anything left to array.
            FlagCheckedData = [FlagCheckedData, inputData];

            % and break the whole process. because there is no data left.
            break

        % adding final block to data is done.
        end

        % save latest size of data. so this way we can know if we have reached the final block.
        lastq = q;
    

    % separating data in blocks done.
    end


    % start cleaning data

    % output data will be stored here. seperated by blocks.
    outputData = {};


    % itterate over the blocks.
    for k = FlagCheckedData
    % for each block do:

        % first convert each cell to a matrix so we can process it.
        k = cell2mat(k);
        
        % for each block, decoded data will be stored here.
        tmpOutData = [];

        % we use a buffer to add decoded numbers to list.
        % thats for checking for similarities to flag.
        % so at first of each block buffer is empty.
        buffer = [];
        
        % get size of a block
        q = size(k);
        q = q(2);

        % number of cascaded ones seen.
        % at the begining of each block, it is zero.
        numberOfOnes = 0;

        % itterate over numbers in a block
        for b = 1:q

            % so if bit was a 1
            if k(b) == 1
            
                % add ones counter by 1
                numberOfOnes = numberOfOnes + 1;

                % and add the number (which is ,of course, 1) to the buffer.
                buffer = [buffer k(b)];
            
            % but if the number was not a 1
            else

                % if there are enough ones cascaded, so we have found a similarity
                if numberOfOnes == flagSize - 1

                    % add buffer to output list. but ignoring the number right after the buffer.
                    tmpOutData = [tmpOutData buffer];

                    % buffer is added. so empty the buffer.
                    buffer = [];

                % but if everything is normal and there are not too much ones cascaded               
                else

                    % add buffer to output list. add this number seed too.
                    tmpOutData = [tmpOutData buffer k(b)];

                    % buffer is added to the output list. so empty it.
                    buffer = [];
                
                % avoiding flag similarity adds, done.
                end

                % the number we have seen is not 1. so reset the counter.
                numberOfOnes = 0;

            % adding number to output list done.
            end


        % cleaning this data block done
        end

        % at the end of decoding a block, buffer might be not empty.
        % this happens when latest number in a block was a 1
        % so lets just add anything left to output list.
        tmpOutData = [tmpOutData buffer];

        % so after that, each cleaned block should be added to whole data.
        % we add this to a cell array. to be able to detect and avoid errors in decoding.
        % add this block to output data
        outputData = [outputData tmpOutData];
    
    % cleaning all data blocks done
    end

    % this is going to be returned
    outputData;

% checking flags and cleaning data done.
end
