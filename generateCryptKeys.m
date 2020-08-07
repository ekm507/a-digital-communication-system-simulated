function keys = generateCryptKeys (numberOfKeys, lengthOfKeys, M)

    keys = randi(M, numberOfKeys, lengthOfKeys) - 1;

end