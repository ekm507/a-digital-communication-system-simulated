% this function calculates some of two vectors. each representing a number in base M

% [sum of two vectors, carry out] = f(vector1, vector2, M, carry in)
function [outputMat, carry] = sumMatrix (mat1, mat2, M, carry)

    q1 = size(mat1);
    q1 = q1(2);

    q2 = size(mat2);
    q2 = q2(2);

    % check if sizes are equal
    if q2 > q1
        mat1 = [zeros(1, q2-q1), mat1];
    elseif q1 > q2
        mat2 = [zeros(1, q1-q2), mat2];
    end

    q = q1;

    outputMat = zeros(1, q);

    for i = q:-1:1
        s = mat1(i) + mat2(i) + carry;
        carry = floor(s / M);
        s = mod(s, M);
        outputMat (i) = s;
    end

end