clc;
clear;
close all;
% communication lib. for coding in MATLAB, comment the line below
pkg load communications;

snr = -50; % signal to noise ratio in channel
M = 4; % PSK size. 2 for BPSK
sampling_frequency = 6 * 1000 * 1000 * 1000; % 6 Giga sample per second
carrier_frequency = 30*1000*1000; % 30 Mega Hertz
signalLength = 2 * 1 / carrier_frequency; % two periods
ParityBlockSize = 4; % block size for arity adding algorithm
shiftSize = 0;

dataSize = 8;
data = randi([0 M-1], dataSize, 1).';

disp('parity add');
k1 = parityAdd(data, ParityBlockSize, M)
disp('diff code');
k2 = diffCode(k1, M);
disp('modulate psk');
s1 = modulatePSK(k2, M, signalLength, sampling_frequency, carrier_frequency);
disp('channel');
s2 = channelPass(s1, snr, shiftSize);
disp('demodulate psk');
k3 = demodulatePSK(s2, M, signalLength, sampling_frequency, carrier_frequency);
disp('diff decode');
k4 = diffDecode(k3, M)
disp('parity check');
k5 = parityCheck(k4, ParityBlockSize, M);
