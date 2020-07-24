% start routines.
clc;
clear;
close all;

% communication lib. for coding in MATLAB, comment the line below
pkg load communications;

% signal to noise ratio in channel
snr = 6; % deci Bells

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
% size of block should be devidable to data blocks.
flagBlockSize = 8;

% data size in numbers. each data will be in size of M
dataSize = 800;

% generate a random data
data = randi([0 M-1], dataSize, 1).';



tic

disp('parity add');
% add base M modular numbers to data
k1 = parityAdd(data, ParityBlockSize, M);

disp('add Flag');
% differential coding
k2 = addFlag(k1, flagBlockSize, flagSize);

disp('diff code');
% differential coding
k3 = diffCode(k2, M);

disp('modulate psk');
% modulate data in MPSK
s1 = modulatePSK(k3, M, signalLength, sampling_frequency, carrier_frequency);

% create a filter for channel
[b,a] = butter(1, carrier_frequency/ sampling_frequency * 2);

disp('channel');
% pass signal through channel
s2 = channelPass(s1, snr, shiftSize, b, a);

disp('demodulate psk');
% demodulate MPSK modulated signal. output will be some phasors.
p1 = demodulatePSK(s2, M, signalLength, sampling_frequency, carrier_frequency);

disp('diff decode (demodulate angles)');
% convert phasors to numbers. this will do a differential decoding also.
k4 = PSKangleDemod(p1, M);


disp('check flags');
% finding flags in data and removing additional zeros added by addflag
%  (this is the reverse function of addFlag)  
k5 = checkFlag(k4, flagSize);

% output of flag check is a cell array.
% that is because all data blocks are seperated to prevent errors in decoding.
% but for now, we just need to concatenate all matrices in cells.
k5 = cell2mat(k5);

disp('parity check');
% by checking added mod bits, check for errors.
k6 = parityCheck(k5, ParityBlockSize, M);

toc

% show number if errors in output
number_of_errors = sum(data ~= k6)
