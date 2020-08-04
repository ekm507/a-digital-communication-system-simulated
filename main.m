% start routines.
clc;
clear;
close all;

% communication lib. for coding in MATLAB, comment the line below
pkg load communications;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% first set some preferences.

% signal to noise ratio in channel
snr = 10; % deci Bells

% PSK modulation size. 2 for BPSK. 4 for QPSK.
M = 2; % number size. this is called M in this project.

% carrier signal frequency for modulating PSK
carrier_frequency = 30*1000*1000; % 30 Mega Hertz

% sampling frequency for signal processings.
% keep nyquist theoreum in mind.
sampling_frequency = carrier_frequency * 200; % 200 times carrier frequency.

% signal length in phase ( cycles ).
signal_phase_length = 2 * 2*pi; % 2 cycles

% signal length in samples.
signalLength = signal_phase_length / (2 * pi * carrier_frequency); % seconds

% block size for parity adding algorithm
% this is not actual parity in M > 2. it is mod of sum of data to M.
ParityBlockSize = 4; % 4 numbers.

% shiftSize: shift size in channel. use negative numbers to add zero signal to the begining.
% for shifting over time instead of samples:
% shif_Time = 0;
% shiftSize = shif_Time * sampling_frequency;
shiftSize = 0; % samples

% size of flag numbers to add to each block
flagSize = 3;

% size of a block to add a flag to.

% for encoding text into bits.
% this denotes nomber of bits should be used for coding each character of text.
numbersPerSymbol = 8;

% size of a block to add index bits to
indexBlockSize = 10;

% number of bits in index bits.
indexSize = 2;

% size of block should be devidable to data blocks.
% since flag is for finding begining of data blocks and there is
% no other way provided to do so, then
% it is recommended to use same blocks for adding flags and adding index to.
% to do that, flag block size should be equal to block size of index added data. (output of addIndex)
flagBlockSize = indexBlockSize + indexSize;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get data.

% if you want to use text as data, use source coding block.
% otherwise, uncomment next lines.

% % data size in numbers. each data will be in size of M
% dataSize = 1600;
% % generate a random data
% data = randi([0 M-1], dataSize, 1).';

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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% start the system

% start ticking the timer. so at the end we
% will know how much time the whole process takes.
tic

%%%%%%%%%%%%%%%%%%%%%% Adding parity %%%%%%%%%%%%%%%%%%%

disp('parity add');
% add base M modular numbers to data
parityAddedData = parityAdd(data, ParityBlockSize, M);


%%%%%%%%%%%%%%%%%%%%%% Adding index %%%%%%%%%%%%%%%%%%%

% add indices to data blocks
indexAddedData = addIndex(parityAddedData, indexBlockSize, indexSize, M);


%%%%%%%%%%%%%%%%%%%%%% Adding flags %%%%%%%%%%%%%%%%%%%

disp('add Flag');
% differential coding
flagAddedData = addFlag(indexAddedData, flagBlockSize + indexSize, flagSize);


%%%%%%%%%%%%%%%%%%% differential coding %%%%%%%%%%%%%%%%

disp('diff code');
% differential coding
diffCodedData = diffCode(flagAddedData, M);


%%%%%%%%%%%%%%%%%%%%%% modulating PSK %%%%%%%%%%%%%%%%%%

disp('modulate psk');
% modulate data in MPSK
transmitterOutputSignal = modulatePSK(diffCodedData, M, signalLength, sampling_frequency, carrier_frequency);


%%%%%%%%%%%% passing signal thorugh channal %%%%%%%%%%%%

% create a filter for channel
[b,a] = butter(1, carrier_frequency/ sampling_frequency * 2);

disp('channel');
% pass signal through channel
receiverInputSignal = channelPass(transmitterOutputSignal, snr, shiftSize, b, a);


%%%%%%%%%%%%%%%%%%%%%% demodulating psk %%%%%%%%%%%%%%%%%

disp('demodulate psk');
% demodulate MPSK modulated signal. output will be some phasors.
demodulatedPhasors = demodulatePSK(receiverInputSignal, M, signalLength, sampling_frequency, carrier_frequency);


%%%%%%%%%%%%%%%%% differential decoding %%%%%%%%%%%%%%%%%

disp('diff decode (demodulate angles)');
% convert phasors to numbers. this will do a differential decoding also.
diffDecodedData = PSKangleDemod(demodulatedPhasors, M);


%%%%%%%%%%%%%%%%%%%%%% checking flags %%%%%%%%%%%%%%%%%%%

disp('check flags');
% finding flags in data and removing additional zeros added by addflag
%  (this is the reverse function of addFlag)  
flagCheckedData = checkFlag(diffDecodedData, flagSize);


%%%%%%%%%%%%%%%%%%%%%% checking indices %%%%%%%%%%%%%%%%%%%

% output of flag check is a cell array.
% that is because all data blocks are seperated to prevent errors in decoding.
% but for now, we just need to concatenate all matrices in cells.

indexCheckedData = checkIndex(flagCheckedData, 2);

k5_2 = indexCheckedData(:, 2);

k5_2 = k5_2.';

k5_3 = cell2mat(k5_2);


%%%%%%%%%%%%%%%%%%%%%% checking parity %%%%%%%%%%%%%%%%%%%

disp('parity check');
% by checking added mod bits, check for errors.
parityCheckedData = parityCheck(k5_3, ParityBlockSize, M);


% transmission finish.
% so output the time this process took.
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% done. check for errors and so.

% decode bits and re-encode it to text.
outText = sourceDecode(parityCheckedData, numbersPerSymbol, M);

% open a file to write output into
file = fopen('output.txt', 'w');

% write output text into the file
fwrite(file, outText);

% close the output file
fclose(file);

% show number if errors in output
number_of_errors = sum(data ~= parityCheckedData)
