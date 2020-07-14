clc;
clear;
close all;
% communication lib. for coding in MATLAB, comment the line below
pkg load communications;

snr = -10; % signal to noise ratio in channel
M = 4; % PSK size. 2 for BPSK
carrier_frequency = 30*1000*1000; % 30 Mega Hertz
% sampling_frequency = 6 * 1000 * 1000 * 1000; % 6 Giga sample per second
sampling_frequency = carrier_frequency * 200;
signal_phase_length = 2 * 2*pi;
%signalLength = 2 * 1 / carrier_frequency; % two periods
signalLength = signal_phase_length / (2 * pi * carrier_frequency);
ParityBlockSize = 4; % block size for arity adding algorithm
shiftSize = 0;

dataSize = 8000;
data = randi([0 M-1], dataSize, 1).';

disp('parity add');
k1 = parityAdd(data, ParityBlockSize, M);
disp('diff code');
k2 = diffCode(k1, M);
disp('modulate psk');
s1 = modulatePSK(k2, M, signalLength, sampling_frequency, carrier_frequency);
disp('channel');
s2 = channelPass(s1, snr, shiftSize);
disp('demodulate psk');
p1 = demodulatePSK(s2, M, signalLength, sampling_frequency, carrier_frequency);
disp('diff decode (demodulate angles)');
k3 = PSKangleDemod(p1, M);
disp('parity check');
k4 = parityCheck(k3, ParityBlockSize, M);
