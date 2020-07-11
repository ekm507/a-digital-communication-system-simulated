% for running code in GNU octave, uncomment next line. but for running in MATLAB, comment it.
pkg load communications;
clc;
clear;
close all;

%---------------Pre Settings----------------------------------------------------

% data size
n = 8;
% carrier signal frequency
fs = 30;
% sampling frequency
sampling_frequency = 1000;
% length of a carrier signal in time domain(secounds)
signalLength = 2 * pi / 15;
% psk modulation number
M = 2;
% SNR in AWGN channel
SNR = -0;
% phase shift in input:
% asinchronizedness in channel
asyinc = 120;
% Block size to add 1 parity bit for it.
ParityBlockSize = 4;

% input data
data = randi([0 M-1],n,1).';

% ----------- Add Parity Bits
dataToAddParity = data;
q = size(dataToAddParity);
q = q(2);
ParityAddedData = [];
for i = [1 : ParityBlockSize : q - ParityBlockSize + 1]
  b = dataToAddParity(i : i + ParityBlockSize - 1);
  c = 0;
  for j = b
  c = xor(c,j);
  end
  ParityAddedData = [ParityAddedData b c];
end



%--------------differencial coding----------------------------------------------
diffCoded_data = ParityAddedData;
last_bit = 0;
q = size(diffCoded_data);
q = q(2);
for i = 1:q
  if diffCoded_data(i) == 1
    last_bit = 1 - last_bit;
  endif
  diffCoded_data(i) = last_bit;
end


% -------------modulation-------------------------------------------------------

dataToModulate = diffCoded_data;
% prepare coefficients for modulation
txSig = pskmod(dataToModulate,M,pi);

% trying to create a carrier signal.
% time domain. 
T = 0:1/sampling_frequency:signalLength;
% one carrier signal
carier = sin(fs*T);


% transmitter's output signal. which is in the ideal form
outputSignal = 0;
q = size(dataToModulate);
q = q(2);

for i = 1:q
    temp = carier * txSig(i);
    outputSignal = [outputSignal,temp];
end
outputSignal = real(outputSignal);

% ----------------Channel-------------------------------------------------------

SignalToPassChannel = outputSignal;
% have signal pass through awgn channel
SignalAfterChannel = awgn(SignalToPassChannel, SNR);

SignalAfterChannel = SignalAfterChannel(asyinc:end);
% ------------Demodulation------------------------------------------------------

SignalToDemodulate = SignalAfterChannel;

T = size(carier);
T = T(2);
output_dem = [];

% Initial Clock Pulse Synchronization
% find the point within a signal size where multiplication output is maximum
c = [];
for ii = 1:T
  b = SignalToDemodulate(ii:ii+T-1);
  c(ii) = abs(mean(b .* carier));
end
[M, ii] = max(c);
% shift the signal
SignalToDemodulate = SignalToDemodulate(ii:end);

% Demodulation process starts
for k = 1:T:length(SignalToDemodulate)
    if k+T-1 > length(SignalToDemodulate)
        break;
    end
    signalBlock = SignalToDemodulate(k:k+T-1);
    Multiplied_Signal = 0;
    
    Multiplied_Signal = signalBlock .* carier;
    if mean(Multiplied_Signal) >= 0
        finded = 1;
    else 
        finded = 0;
    end
    output_dem = [output_dem,finded];    
end

%-----------Differencial Decode-------------------------------------------------
diffDecoded_data = output_dem;
last = 0;
K = size(diffDecoded_data);
K = K(2);
for i = 2:K
  if output_dem(i) == output_dem(i - 1)
    diffDecoded_data(i) = 0;
  else
    diffDecoded_data(i) = 1;
  endif
end


% -----------Parity Check-------------------------------------------------------
dataToCheck = diffDecoded_data;
ParityCheckedData = [];
q = size(dataToCheck);
q = q(2);
for i = [1 : ParityBlockSize + 1 : q - ParityBlockSize + 1 + 1]
  b = dataToCheck(i : i + ParityBlockSize - 1);
  c = 0;
  for j = b
    c = xor(c,j);
  end

  if c != dataToCheck(i + ParityBlockSize)
    disp(i);
  endif
  ParityCheckedData = [ParityCheckedData b];
end

% print number of data error

data2 = data;
q = size(ParityCheckedData);
q = q(2);
data2 = data2(n - q + 1 : end);

error = symerr(data2,ParityCheckedData);
disp('number of error bits received:')
disp(error);
disp('Quality of output data % :')
disp(abs(error - q / 2) / (q / 2) * 100)


