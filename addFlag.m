% This function adds recognizable flags to data.
% to make the flags recognizable, any similarities in data should be avoided.
% flags are like this: 0 1 1 1 ... 1 1 0
% ( a sequence of ones by one zero at each side of sequence)
% lets call number of Ones in data as "flagSize"
% to avoid similarities, the bit after a sequence in data with (flegSize - 1) number of Ones, is not added to output data directly,
% but a zero is added before that.


% output data = f(data to add flag to, size of blocks to add flag at the begining or end of each,
% size of flag. (actual size of flag is flagSize+2 . because of 2 added zeros.) )
function outputData = addFlag (inputData, blockSize, flagSize)


    % number of consequent ones. when this number reaches flagsize, a zero will be added to end of that.
    numberOfOnes = 0;

    % number of bits (mod blockSize). when this reaches blockSize, a flag will be added to data
    numberOfBits = 0;

    % flag sequence. its like : 0 1 1 1 ... 1 0
    partFlag = [0 ones([1, flagSize]) 0];

    % output Data will be stored Here
    outputData = [];

    % add an initial flag to data
    outputData = [outputData partFlag];

    % itterate over numbers in input data
    for b = inputData

        % add one to number of seen numbers. this is to know when to add a flag.
        numberOfBits = numberOfBits + 1;

        % so if there is a conflict in data
        if numberOfOnes >= flagSize - 1

            % add one 0 before next bit
            outputData = [outputData 0 b];

            % and because a zero is added, reset number of cascaded ones
            numberOfOnes = 0;
        
        % but if there is no conflict
        else
            % just add the number to output sequence
            outputData = [outputData b];
        % conflict fixing done
        end

        % is number was one
        if b == 1
            % add 1 to number of cascaded ones.
            numberOfOnes = numberOfOnes + 1;
        % but if it was not one
        else
            % reset counter of cascaded ones.
            numberOfOnes = 0;
        % counting ones done.
        end

        % if number of numbers added are equal to a block size
        if numberOfBits >= blockSize
            % add a flag to output data
            outputData = [outputData partFlag];

            % reset number counter and assume a new block is started.
            numberOfBits = 0;
            % reset number of cascaded ones. because last number in a flag is 0
            numberOfOnes = 0;
        % adding flags done.
        end

    % generating output data done
    end

    % outputDate will be this function's output
end

% an example for myself:
% flag Size = 3 : 0 1 1 1 0
% No flag is going to be added to this data.
% just avoiding conflicts.
% 1 1 1   1 1   1 0   0 0 1 1 1   0 1 1 0
% 1 1 0 1 1 0 1 1 0 0 0 0 1 1 0 1 0 1 1 0 0
% 1 1   1 1   1 1   0 0 0 1 1   1 0 1 1   0