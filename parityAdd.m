% add parity numbers to data.
% but this is in a general form.
% so this is not actual parity always. ( this is parity when M is 2)
% but this is sum of a block, modulo to M
% this works like a general form of xor operator in base 2. but it works in other bases as well.

% data with parity numbers added to it = f( data to add parity to it,
% size of a block to add parity, M (PSK modulation size - also data numbers base.) )
function parityAddedData = parityAdd(data, ParityBlockSize, M)

    % get size of data
    q = size(data);
    q = q(2);

    % parity added data will be stored here
    temp_output = [];

    % itterate over bits in data. jumping in size of a block to check parity of
    for i = 1 : ParityBlockSize : q - ParityBlockSize  +1

        % get a data block
        b = data(i : i + ParityBlockSize - 1);

        % calculate the parity. it is modulo of sum of all the numbers in a block to M
        c = mod(sum(b), M);

        % add parity number to end of the block.
        % and add new blocks to output data 
        temp_output = [temp_output b c];
    
    % adding parity numbers to data done.
    end

    % return data with added parity numbers to each block of it
    parityAddedData = temp_output;
    
end
