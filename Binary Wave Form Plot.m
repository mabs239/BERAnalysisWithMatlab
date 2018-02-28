% Display waveform of binary data and play on soundcard
clc
clear all
fs = 44100; % samling freq
Tb = .01; % bit time
% data = [1 0 1 0 1]; % data

data = randi([0 1],1,50); %binary 1x5
n = round(Tb * fs); % samples per bit
c = ones(n,1).*data;
y = reshape(c,[1 n*length(data)]); % row vector
t=[1:n*length(data)]/fs;
plot(t,y)
xlabel('time')
ylabel('x(t)')
axis([0 max(t) -0.5 1.5]) ; % axis([XMIN XMAX YMIN YMAX]) 
sound(y,fs)
