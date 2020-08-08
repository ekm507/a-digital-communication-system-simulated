function outData = repeatCode (inputData, repeatSize)

   temp = repmat(inputData, repeatSize, 1);
   newSize = length(inputData) * repeatSize;
   temp =  reshape(temp, 1, newSize);
   outData = temp;

end