% start routines.
clc;
clear;
close all;

% communication lib. for coding in MATLAB, comment the line below
pkg load communications;

%%%%%%%%% turn system blocks on or off %%%%%%%%%%%%

% System block diagram is like this

% text --> SourceCode --> parityAdd --> addIndex --> addFlag -->
% diffCode --> repeatCode --> modulate --> channel -->
% demodulate --> angle/diff-Decode --> repeatDecode --> flagCheck -->
% indexCheck --> parityCheck --> sourceDecode --> text

% reading text from file
should_sourceCode = true;

% cryptography blocks
should_encrypt = true;

% parity adding and parity checking blocks
should_addParity = true;

% index adding and index checking blocks
should_addIndex = false;

% flag adding and flag checking blocks
should_addFlag = false;

% repeating data
should_repeatCode = true;

% modulation and demodulation blocks
should_modulate = true;

% channel block
should_passChannel = true;

% check if receiver should use several anteennas
should_useSeveralAntennas = true;

% turn channel filter on or off
channel_shouldFilter = true;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% first set some preferences.

% PSK modulation size. 2 for BPSK. 4 for QPSK.
M = 2; % number size. this is called M in this project.

% for encoding text into bits.
% this denotes nomber of bits should be used for coding each character of text.
numbersPerSymbol = ceil(8 / log2(M));

if should_sourceCode == true
    % one-time-pad encryption block size
    cryptBlockSize = numbersPerSymbol;
else
    cryptBlockSize = 8;
end


% block size for parity adding algorithm
% this is not actual parity in M > 2. it is mod of sum of data to M.
ParityBlockSize = 4; % 4 numbers.

% size of a block to add index bits to
if should_addParity == true
    numberOfParityBlockPerCryptBlock = ceil(cryptBlockSize / ParityBlockSize);
    indexBlockSize = cryptBlockSize + numberOfParityBlockPerCryptBlock;
else
    indexBlockSize = cryptBlockSize;
end

% number of bits in index bits.
indexSize = 2;


% size of a block to add a flag to.

% size of block should be devidable to data blocks.
% since flag is for finding begining of data blocks and there is
% no other way provided to do so, then
% it is recommended to use same blocks for adding flags and adding index to.
% to do that, flag block size should be equal to block size of index added data. (output of addIndex)

if should_addIndex == true
    flagBlockSize = indexBlockSize + indexSize;
else
    flagBlockSize = indexBlockSize;
end

% size of flag numbers to add to each block
flagSize = 3;

% number of repetitions for repeat coding
repeatSize = 3;

% set number of receiver antennas after channel.
% having a few parallel antennas may increase signal quality and give you better BER.
numberOfReceiverAntennas = 1;

% carrier signal frequency for modulating PSK
carrier_frequency = 30*1000*1000; % 30 Mega Hertz

% sampling frequency for signal processings.
% keep nyquist theoreum in mind.
sampling_frequency = carrier_frequency * 200; % 200 times carrier frequency.

% signal length in phase ( cycles ).
signal_phase_length = 2 * 2*pi; % 2 cycles

% signal length in samples.
signalLength = signal_phase_length / (2 * pi * carrier_frequency); % seconds

bitRate = log(M) / log(2) * carrier_frequency * 2 * pi / signal_phase_length;
disp(strcat('channel bit rate = ', num2str(bitRate)));

% signal to noise ratio in channel
snr = -10; % deci Bells

% shiftSize: shift size in channel. use negative numbers to add zero signal to the begining.
% for shifting over time instead of samples:
% shif_Time = 0;
% shiftSize = shif_Time * sampling_frequency;
shiftSize = 0; % samples


if channel_shouldFilter == true
    % create a filter for channel
    [channelFilter_b,channelFilter_a] = butter(1, carrier_frequency/ sampling_frequency * 2);
else
    channelFilter_b = [1 1];
    channelFilter_a = [1 1];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get data.

% start ticking the timer. so at the end we
% will know how much time the whole process takes.
tic

%%%%%%%%%%%%%%%%%%%%%% source encoding %%%%%%%%%%%%%%%%%%%

% % data size in numbers. each data will be in size of M
dataSize = 16000;

% if you want to use text as data, use source coding block.
% check if data should be read from file
if should_sourceCode == true

    disp('source code');

    % open a file to read text to send from
    file = fopen('input.txt');

    % read text to send.
    text = fread(file, '*char');

    % close the input file
    fclose(file);

    % transpose the text matrix. this is necessary for other functions to work properly.
    % because by default, output of fread function is a vertical matrix but we
    % need a siumple horizontal vector.
    text = text.';

    % encode text into bits. so we can process that further.
    data = sourceCode(text, numbersPerSymbol, M);

    initialDataSize = length(data);

% otherwise a random data should be generated.
else

    % % generate a random data
    data = randi([0 M-1], dataSize, 1).';

end

% data will be changed passing through system.
% to be able to check errors at the end of the system,
% initial data should be stored in safe
initialData = data;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% start the system

%%%%%%%%%%%%%%%%%%%%%% encrypt data %%%%%%%%%%%%%%%%%%%
if should_encrypt == true

    disp('encrypt data');

    % get length of data
    q = length(data);

    % to encrypt data, first we need to generate some keys.
    % the same keys will be used in decryption.

    % calculate number of keys needed to be generated
    numberOfKeys = floor(q / cryptBlockSize);
    
    % generate one-time-pad keys
    keys = generateCryptKeys(numberOfKeys, cryptBlockSize, M);

    % encrypt data using one-time-pad keys
    data = encrypt(data, keys, cryptBlockSize, M);

    encryptedData = data;

end

%%%%%%%%%%%%%%%%%%%%%% Adding parity %%%%%%%%%%%%%%%%%%%

% check if this block is turned on
if should_addParity == true

    disp('parity add');
    % add base M modular numbers to data
    data = parityAdd(data, ParityBlockSize, M);

    parityAddedData = data;

end

%%%%%%%%%%%%%%%%%%%%%% Adding index %%%%%%%%%%%%%%%%%%%

% check if this block is turned on
if should_addIndex == true

    % add indices to data blocks
    data = addIndex(data, indexBlockSize, indexSize, M);

    indexAddedData = data;

end

%%%%%%%%%%%%%%%%%%%%%% Adding flags %%%%%%%%%%%%%%%%%%%


% check if this block is turned on
if should_addFlag == true

    disp('add Flag');
    % differential coding
    data = addFlag(data, flagBlockSize, flagSize);

    flagAddedData = data;

end

%%%%%%%%%%%%%%%%%%% repeat coding %%%%%%%%%%%%%%%%%%%%%%

% check if this block is turned on
if should_repeatCode == true

    disp('repeat code');

    % do repeat codig on data.
    data = repeatCode(data, repeatSize);

    repeatCodedData = data;

end

%%%%%%%%%%%%%%%%%%% differential coding %%%%%%%%%%%%%%%%
disp('diff code');
% differential coding
data = diffCode(data, M);

diffCodedData = data;

% now this data is the exact data that is going to get modulated.
% lets display size of it!
disp(strcat("data size = ", num2str(length(data) * log2(M) )));
disp(strcat("coding ratio = ", num2str(length(data) / initialDataSize)));
disp(strcat("actual transmission rate = ", num2str(bitRate * initialDataSize / length(data))));
%%%%%%%%%%%%%%%%%%%%%% modulating PSK %%%%%%%%%%%%%%%%%%

% check if this block is turned on
if should_modulate == true

    disp('modulate psk');
    % modulate data in MPSK
    signal = modulatePSK(data, M, signalLength, sampling_frequency, carrier_frequency);

    modulatedSignal = signal;

% but if this block was off, to prevent errors in other blocks, we should generate a signal.
% for now, an empty signal is OK.
else

    % create empty signal for preventing errors in other blocks
    signal = [];

end

%%%%%%%%%%%% passing signal thorugh channal %%%%%%%%%%%%


% check if this block is turned on
if should_passChannel == true

    disp('channel');

    % check if several antennas in receiver should be used.
    if should_useSeveralAntennas == true

        % there might be several antennas in receiver.
        % input signal of each antenna will be stored here
        antennaSignal = [];

        % for each antenna, we simulate the same channel
        % because we assume that all the conditions are same for all of them.
        % for each antenna do:
        for i = 1:numberOfReceiverAntennas

            % pass signal through channel
            antennaSignal(i, :) = channelPass(signal, snr, shiftSize, channelFilter_b, channelFilter_a);

        % receiving signal through same channel but with multiple antennas done.
        end

        % now its time to sum all the received signals.
        signal = sum(antennaSignal, 1);

    % if there is only 1 antenna needed, just do 1 channelPass for it
    else

        % pass signal through channel.    
        signal = channelPass(signal, snr, shiftSize, channelFilter_b, channelFilter_a);

        antennaSignal = signal;

    end


end

%%%%%%%%%%%%%%%%%%%%%% demodulating psk %%%%%%%%%%%%%%%%%

% check if this block is turned on
if should_modulate == true

    disp('demodulate psk');
    % demodulate MPSK modulated signal. output will be some phasors.
    demodulatedPhasors = demodulatePSK(signal, M, signalLength, sampling_frequency, carrier_frequency);

end

%%%%%%%%%%%%%%%%% differential decoding %%%%%%%%%%%%%%%%%

% check if this block is turned on
if should_modulate == true

    disp('diff decode (demodulate angles)');
    % convert phasors to numbers. this will do a differential decoding also.
    data = PSKangleDemod(demodulatedPhasors, M);


% but if modulation is turned off, then a pure differential decoding is needed.
else

    disp('diff Decode')
    % decode data differentially
    data = diffDecode(data, M);

end

diffDecodedData = data;

%%%%%%%%%%%%%%%%%%% repeat decoding %%%%%%%%%%%%%%%%%%%%%

% check if this block is turned on
if should_repeatCode == true

    disp('repeat decode');

    % do repeat decoding
    data = repeatDecode(data, repeatSize);

    repeatDecodedData = data;

end

%%%%%%%%%%%%%%%%%%%%%% checking flags %%%%%%%%%%%%%%%%%%%


% check if this block is turned on
if should_addFlag == true

    disp('check flags');
    % finding flags in data and removing additional zeros added by addflag
    %  (this is the reverse function of addFlag)  
    data = checkFlag(data, flagSize);

    flagCheckedData = data;

end



%%%%%%%%%%%%%%%%%%%%%% checking indices %%%%%%%%%%%%%%%%%%%

% output of flag check is a cell array.
% that is because all data blocks are seperated to prevent errors in decoding.
% but for now, we just need to concatenate all matrices in cells.

% check if this block is turned on
if should_addIndex == true

    % if checkFlag block is off, then there is no need to convert data from cell to matrix
    % otherwise it is needed
    if should_addFlag == true

        data = checkIndex(data, indexBlockSize, indexSize);
        % convert output of checkFlag which is a cell array, to a plain vector

        indexCheckedData = data;

    else

        % remove indices from data
        data = indexRemove(data, indexBlockSize, indexSize);

        indexRemovedData = data;

    end

% but if block is turned off, output of checkFlag which is a cell array,
% should be turned into a vector to avoid errors in other blocks
else
    
    % if checkFlag block is off, then there is no need to convert data from cell to matrix
    % otherwise it is needed
    if should_addFlag == true

        % convert output of checkFlag which is a cell array, to a plain vector
        data = cell2mat(data);

    end

end

%%%%%%%%%%%%%%%%%%%%%% checking parity %%%%%%%%%%%%%%%%%%%

% check if this block is turned on
if should_addParity == true

    disp('parity check');
    % by checking added mod bits, check for errors.
    data = parityCheck(data, ParityBlockSize, M);

    parityCheckedData = data;

end

% transmission finish.
% so output the time this process took.

%%%%%%%%%%%%%%%%%%%%%% decrypting %%%%%%%%%%%%%%%%%%%

if should_encrypt == true

    disp('decrypt data');

    if should_addIndex == true

        data = decryptWithIndex(data, keys, cryptBlockSize, M);

    else

        % decrypt data using  one-time-pad keys.
        % keys should be generated in the transmitter part and
        % the same keys should be used here.
        data = decrypt(data, keys, cryptBlockSize, M);

    end

    decryptedData = data;

end

%%%%%%%%%%%%%%%%%%%%%% source decode %%%%%%%%%%%%%%%%%%%

% if data should be converted into ascii text
if should_sourceCode == true

    disp('source decode')

    % decode bits and re-encode it to text.
    outText = sourceDecode(data, numbersPerSymbol, M);

    % display system output text
    outText

    % open a file to write output into
    file = fopen('output.txt', 'w');

    % write output text into the file
    fwrite(file, outText);

    % close the output file

    fclose(file);

end

toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% done. check for errors and so.
q0 = length(initialData);
q = length(data);

dataToCheck = initialData(q0 - q + 1 : end);

% show number if errors in output
number_of_errors = sum(data ~= dataToCheck)
