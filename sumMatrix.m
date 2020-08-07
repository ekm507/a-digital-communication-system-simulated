% this function calculates some of two vectors. each representing a number in base M

% [sum of two vectors, carry out] = f(vector1, vector2, M, carry in)
function [outputMat, carry] = sumMatrix (mat1, mat2, M, carry)

    % get size of first matrix
    q1 = size(mat1);
    q1 = q1(2);

    % get size of second matrix
    q2 = size(mat2);
    q2 = q2(2);

    % check if sizes are equal
    % if sizes are not equal, enough zero padding should be
    % done in the begining of smaller matrix to make the sizes equal

    % if matrix 2 is bigger in size
    if q2 > q1

        % add enough zeros to the begining of matrix 1, so that sizes will be equal
        mat1 = [zeros(1, q2-q1), mat1];

    % if matrix 1 is bigger in size
    elseif q1 > q2

        % add enough zeros to the begining of matrix 1, so that sizes will be equal
        mat2 = [zeros(1, q1-q2), mat2];

    % practice of making size of matrices the same is done
    end

    % size of matrix
    q = q1;

    % output of summition will be stored here
    outputMat = zeros(1, q);

    % for each digit in matrices(from smalles to biggest) do:
    for i = q:-1:1

        % calculate sum of that digit in two matrices
        s = mat1(i) + mat2(i) + carry;

        % calculate carry of sum for that digit
        carry = floor(s / M);

        % calculate one-digit sum
        s = mod(s, M);

        % add sum digit to output matrices digits
        outputMat (i) = s;
    
    % calculating sum is done
    end

    % at the end, latest carry will also be returned by the function alongside sum of two matrices

end