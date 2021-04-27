% LDPC Simulation under Erasure Channel
clc; 
clear;

% The Size of LDPC Generate Matrix
M = 64;
N = 128;

% The Number of 1 in each column
onePerCol = 3;

% Erasure Probability
del = 0.1:0.02:0.4;

% The Number of Iteration Times
iter = 10;

% The Number of Frames (1 frame = 64 bits)
frame = 9;

% Generate LDPC Generate Matrix
H = makeLdpc(M, N, onePerCol);

% Randomly generate data and pass through Erasure Channel
for i=1:1:length(del)
   fer(i) = 0;
   error(i) = 0;
   
   % Randomly generate 0/1 as source data
   dSource = round(rand(M, frame));
   % RS encodinng
   rs_codes = RS_encoder(dSource,3,5);
   len = size(rs_codes);
   % LDPC encoding
   for j = 1:len(2)
      % Encoding
      [c, newH] = makeParityChk(rs_codes(:, j), H);
      u = [c; rs_codes(:, j)];
      % BPSK Modulation
      bpskMod = 2*u - 1;
      % Pass through Erasure Channel
      delcheck=randperm(128,128);
      tx=((delcheck-128*del(i))>0)'.*bpskMod+((delcheck-128*del(i))<=0)'*0.1;
      % Decoding
      % LDPC Decoding
      vhat = BPBEC(tx, newH, del(i), iter);      
      % Culmulative Frame Error
      error(i)=(sum(u~=vhat')~=0)+error(i);
   end
   fer(i)=error(i)/len(2);
end

semilogy(del, fer,'o-');
xlabel('DEL');
ylabel('FER');
title('FER vs DEL with BEC channel');

