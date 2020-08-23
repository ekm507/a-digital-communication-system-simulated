% this function converts a matrix that its elements
% represent digits of a number in base M, to a plain number.

function number = matrix2number(matrix, M)

    % number will be stored here
    number = 0;


    % for each digit in matrix do (little endian I think)
    for digit = matrix

        % add that digit to number
        number = number * M + digit;
    
    % converting from base M done
    end

% returns the generated number
end