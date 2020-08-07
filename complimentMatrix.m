function outData = complimentMatrix (inputMatrix, M)

    mat = (M - 1) - inputMatrix;
    outData = sumMatrix(mat, 1, M, 0);

end