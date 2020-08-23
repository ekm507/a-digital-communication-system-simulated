% this function does repeat coding.
% repeat coding is repeating each digit a number of times.

% output data = f(data to repeat code, number of repetitions for each digit)
function outData = repeatCode (inputData, repeatSize)

   % first repeat the vector vertically and generate a 2D matrix
   temp = repmat(inputData, repeatSize, 1);

   % calculate the new size
   newSize = length(inputData) * repeatSize;

   % concatenate all vectors in matrix
   temp =  reshape(temp, 1, newSize);

   % repeat coded vector is ready
   outData = temp;

end