% symbol error rate for binary VR-MPPM codes
clc
clear
c4c1=[
     0     0     0     1
     0     0     1     0
     0     1     0     0
     1     0     0     0
];
c4c2=[     
     0     0     0     1     1     1
     0     1     1     0     0     1
     1     0     1     0     1     0
     1     1     0     1     0     0
];
c4c3=[
     0     1     1     1
     1     0     1     1
     1     1     0     1
     1     1     1     0
];

code = c4c1; % Select code according to brightness
iterations = 1000;
tx=[];
codeLength=length(code(1,:));
codeSize = length(code(:,1));
encodingBits = floor(log2(codeSize));
largestSymbol = 2^encodingBits-1;
data = randi([0 largestSymbol],1,iterations);
% tx = zeros(1,iterations*codeLength)
for i=1:iterations % Generate transmit matrix
    tx = [tx code(1+data(i),:)];
end
tx;
snrArr=[];
softSymErrArr=[];
hardSymErrArr=[];
softBitErrArr=[];
hardBitErrArr=[];
for snr=-10:-1
    rx = awgn(tx,snr,'measured','db');
    mat = vec2mat(rx,codeLength);
    softOut = zeros(1,iterations);
    hardOut = zeros(1,iterations);
    for i=1:iterations
        datai=data(i);
        rxx = mat(i,:);
        % Soft Decoding
        D = pdist2(rxx,code(1:largestSymbol+1,:)); % Eucledian distance
        [a b]=min(D);
        softOut(i) = b-1;
        % Hard Decoding
        rxx = (rxx>.5)*1; % Multiply by 1 to suppress warning
        D = pdist2(rxx,code(1:largestSymbol+1,:),'hamming'); % Hamming distance
        [a b]=min(D);
        hardOut(i) = b-1;
    end
    [a softSymErr]=symerr(data,softOut);
    [a hardSymErr]=symerr(data,hardOut);
    [a softBitErr]=biterr(data,softOut,encodingBits);
    [a hardBitErr]=biterr(data,hardOut,encodingBits);
    snrArr = [snrArr snr];
    softSymErrArr = [softSymErrArr softSymErr];
    hardSymErrArr = [hardSymErrArr hardSymErr];
    softBitErrArr = [softBitErrArr softBitErr];
    hardBitErrArr = [hardBitErrArr hardBitErr];
end
semilogy(snrArr,softBitErrArr,'b',snrArr,hardBitErrArr,'r')
xlabel('S/N (dB)')
xlabel('Eb/No (dB)')
ylabel('Bit Error Rate')
grid

