%  MATLAB Codes to Simulate SER of PPM Based on HDD and SDD
% Optical Wireless Communications System and Channel Modelling with MATLAB  
% Abu Bakar Siddique 
% Adopted to Matlab '9.2.0.538062 (R2017a)' 
 
M=3;% bit resolutions
Lavg=2^M;% Average symbol length
nsym=500;% number of PPM symbols
Lsig=nsym*Lavg;% length of PPM slots
Rb=1e6;% Bit rate
Ts=M/(Lavg*Rb);% slot duration
Tb=1/Rb;% bit duration
EbN0=-10:5;% Energy per slot
EsN0=EbN0+10*log10(M);% Energy per symbol
SNR=10.^(EbN0./10);
 
for ii=1:length(EbN0)
    PPM= generate_PPM(M,nsym);
    MF_out=awgn(PPM,EsN0(ii)+3,'measured');%hard decision decoding
    Rx_PPM_th=zeros(1,Lsig);
    Rx_PPM_th(find(MF_out>0.5))=1;
    [No_of_Error(ii) ser_hdd(ii)]= biterr(Rx_PPM_th,PPM);% soft decision decoding
    PPM_SDD=[];
    start=1;
    finish=2^M;
    
    for k=1:nsym
        temp=MF_out(start:finish);
        m=max(temp);
        temp1=zeros(1,2^M);
        temp1(find(temp==m))=1;
        PPM_SDD=[PPM_SDD temp1];
        start=finish+1;
        finish=finish+2^M;
    end
    [No_of_Error(ii) ser_sdd(ii)]=biterr(PPM_SDD,PPM);
end
% theoretical calculation
Pse_ppm_hard=qfunc(sqrt(M*2^M*0.5*SNR));
semilogy(EbN0,Pse_ppm_hard,'k-','linewidth',2);
Pse_ppm_soft=qfunc(sqrt(M*2^M*SNR));
semilogy(EbN0,Pse_ppm_soft,'r-','linewidth',2);
 
function PPM=generate_PPM(M,nsym)
    % function to generate PPM
    % 'M' bit resolution
    % 'nsym': number of PPM symbol
    PPM=[];
    for i= 1:nsym
        % temp=randint(1,M); % random binary number
        temp=randi([0 1],1,M); % random binary number
        dec_value=bi2de(temp,'left-msb'); % converting to decimal value
        temp2=zeros(1,2^M); % zero sequence of length 2^M
        temp2(dec_value+1)=1; 
        % placing a pulse accoring to decimal value,
        % note that in matlab index doesnot start from zero, so
        % need to add 1;
        PPM=[PPM temp2]; % PPM symbol
    end
end
