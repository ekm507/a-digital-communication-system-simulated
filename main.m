% start routines.
clc;
clear;
close all;

% communication lib. for coding in MATLAB, comment the line below
pkg load communications;

% signal to noise ratio in channel
snr = 10; % deci Bells

% PSK modulation size. 2 for BPSK. 4 for QPSK.
M = 4; % number size. this is called M in this project.

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
flagSize = 6;

% size of a block to add a flag to.
% size of block should be devidable to data blocks.
flagBlockSize = 8;

% data size in numbers. each data will be in size of M
dataSize = 80;

% generate a random data
data = randi([0 M-1], dataSize, 1).';

disp('parity add');
% add base M modular numbers to data
k1 = parityAdd(data, ParityBlockSize, M);

disp('add Flag');
% differential coding
k2 = addFlag(k1, flagBlockSize, flagSize);

disp('diff code');
% differential coding
k3 = diffCode(k1, M);

disp('modulate psk');
% modulate data in MPSK
s1 = modulatePSK(k3, M, signalLength, sampling_frequency, carrier_frequency);


[b,a] = butter(1, carrier_frequency/ sampling_frequency * 2);

disp('channel');
% pass signal through channel
s2 = channelPass(s1, snr, shiftSize, b, a);



tic
disp('demodulate psk');
% demodulate MPSK modulated signal. output will be some phasors.
p1 = demodulatePSK(s2, M, signalLength, sampling_frequency, carrier_frequency);
toc

disp('diff decode (demodulate angles)');
% convert phasors to numbers. this will do a differential decoding also.
k4 = PSKangleDemod(p1, M);

disp('parity check');
% by checking added mod bits, check for errors.
k5 = parityCheck(k4, ParityBlockSize, M);

number_of_errors = sum(xor(data, k5))