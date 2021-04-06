% LDPC Simulation under Erasure Channel
clc; 
clear;

% The Size of LDPC Generate Matrix
M = 64;
N = 128;

% The Number of 1 in each column
onePerCol = 3;

% Erasure Probability
del = 0.2:0.05:0.4;

% The Number of Iteration Times
iter = 50;

% The Number of Frames (1 frame = 64 bits)
frame = 500;

% Generate LDPC Generate Matrix
H = makeLdpc(M, N, onePerCol);

% Randomly generate data and pass through Erasure Channel
for i=1:1:length(del)
   fer(i) = 0;
   error(i) = 0;
    % Randomly generate 0/1 as source data
   dSource = round(rand(M, frame));
   for j = 1:frame  
      % Encoding
      [c, newH] = makeParityChk(dSource(:, j), H);
      u = [c; dSource(:, j)];
      % BPSK Modulation
      bpskMod = 2*u - 1;
      % Pass through Erasure Channel
      delcheck=randperm(128,128);
      tx=((delcheck-128*del(i))>0)'.*bpskMod+((delcheck-128*del(i))<=0)'*0.1;
      % Decoding
      vhat = BPBEC(tx, newH, del(i), iter);
      % Culmulative Frame Error
      error(i)=(sum(u~=vhat')~=0)+error(i);
   end
   fer(i)=error(i)/frame;
end

% Plot Fer vs. Erasure Rate
set(0,'defaultTextFontSize', 12)
set(0,'defaultAxesFontSize', 12)
set(0,'defaultAxesFontName','Times')
set(0,'defaultTextFontName','Times')
set(0,'defaultFigurePaperPositionMode','auto')
set(0,'DefaultFigurePaperType','<custom>')
set(0,'DefaultFigurePaperSize',[14.5 7.7])

semilogy(del, fer,'k-v','linewidth',1);
xlabel('DEL');
ylabel('FER');
title('FER vs DEL with BEC channel');