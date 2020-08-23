% this function calculates n'th compliment of a vector which represents a number in base n

% n'th complimented vector = f(vector to calculate n'th compliment of, M)
function outData = complimentMatrix (inputMatrix, M)

    % first calculate n-1'th compliment
    mat = (M - 1) - inputMatrix;

    % add by 1
    outData = sumMatrix(mat, 1, M, 0);

end