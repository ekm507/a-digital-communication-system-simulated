% remove parity numbers from data.
% and check for any errors

% this is a parity checking
% but this is in a general form.
% so this is not actual parity always. ( this is parity when M is 2)
% but this is sum of a block, modulo to M
% this works like a general form of xor operator in base 2. but it works in other bases as well.

% data with parity numbers removed from it= f( data to remove parity from it and check for errors,
% size of a parity block( this is the same number you provide to parityAdd function),
% M (PSK modulation size - also data numbers base.) )
function outputData = parityCheck (inputData, ParityBlockSize, M)

    % number of errors detected by parity check will be stored here.
    numberOdErrorsDetected = 0;

    % data with parity numbers removed from, will be stored here.
    ParityCheckedData = [];

    % get size of input data
    q = size(inputData);
    q = q(2);

    %
    a = mod(q + 1 - 1, ParityBlockSize + 1);
    max_decodable = q - ParityBlockSize  - a;

    % itterate over numbers in each block of data
    for i = 1 : ParityBlockSize + 1 : max_decodable

        % get a block of data
        b = inputData(i : i + ParityBlockSize - 1);

        % calculate parity of it
        c = mod(sum(b), M);

        % so if there are conflicts with parity number provided by parityAdd functions
        if c ~= inputData(i + ParityBlockSize)
            % do whatever you want to do!
            % errors can't be corrected yet!
            % as an example you can count number of errors and calculate quality of system
        %    disp(i);

            % count number of errors detected.
            % we have found 1 error. so add it by 1.
            numberOdErrorsDetected = numberOdErrorsDetected + 1;

        % checking for conflicts done
        end

        % remove that parity number from data and add cleaned block to output
        ParityCheckedData = [ParityCheckedData b];
    
    % checlong for parity numbers and removing them from data done.
    end

    % print number of errors detected by parity check:
    disp(strcat("number of errors detected by parity check = ", num2str(numberOdErrorsDetected)));

    
    % return data with parity numbers removed.
    outputData = ParityCheckedData;
    
end
