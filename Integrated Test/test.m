M = 64;
N = 128;
frame = 9;
onePerCol = 3;
iter = 10;

del = 0.35;

dSource = round(rand(M, frame));
% RS encodinng
rs_codes = RS_encoder(dSource,3,5);
len = size(rs_codes);

H = makeLdpc(M, N, onePerCol);
err = 0;

dec_msg_ldpc = zeros(M,len(2));

for j = 1:len(2)
      % Encoding
      [c, newH] = makeParityChk(rs_codes(:, j), H);
      u = [c; rs_codes(:, j)];
      % BPSK Modulation
      bpskMod = 2*u - 1;
      % Pass through Erasure Channel
      delcheck=randperm(128,128);
      tx=((delcheck-128*del)>0)'.*bpskMod+((delcheck-128*del)<=0)'*0.1;
      
      % Decoding
      % LDPC Decoding
      vhat = BPBEC(tx, newH, del, iter);

      b = vhat(65:128);
      b = b';
      dec_msg_ldpc(:,j) = b';
      % Culmulative Frame Error
      err=(sum(u~=vhat')~=0)+err;
end


err2 = 0;
for i = 1:M
    msg = dec_msg_ldpc(i,:);
    dec_vec_rs = RS_dec2(msg,3,5);
    disp(dSource(i,:))
    disp(dec_vec_rs)
    disp(dec_msg_ldpc(i,:))
    err2 =(sum(dSource(i,:)~=dec_vec_rs)~=0)+err2;
end
