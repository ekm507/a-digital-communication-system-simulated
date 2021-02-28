% this function generated one-time-pad keys
% the same keys can be used for encrypting and decrypting.

% generated keys = f(number of keys needed, size of each key, M)
function keys = generateCryptKeys (numberOfKeys, lengthOfKeys, M)

    % generate keys using random number generator
    keys = randi(M, numberOfKeys, lengthOfKeys) - 1;

end