clc;
clear;
close all;
% communication lib. for coding in MATLAB, comment the line below
pkg load communications;

snr = 15; % signal to noise ratio in channel
M = 4; % PSK size. 2 for BPSK
sampling_frequency = 6 * 1000 * 1000 * 1000; % 6 Giga sample per second
carrier_frequency = 30*1000*1000; % 30 Mega Hertz
signalLength = 2 * 1 / carrier_frequency; % two periods
ParityBlockSize = 4; % block size for arity adding algorithm
shiftSize = 0;

dataSize = 10;
data = randi([0 M-1], dataSize, 1).'

k1 = parityAdd(data, ParityBlockSize);
k2 = diffCode(data, M);
s1 = modulatePSK(k2, M, signalLength, sampling_frequency, carrier_frequency);
s2 = channelPass(s1, snr, shiftSize);
k3 = demodulatePSK(s2, M, signalLength, sampling_frequency, carrier_frequency);
k4 = diffDecode(k3, M)
k5 = parityCheck(k4, ParityBlockSize);
