global M frame Bin_Source;
M = 64; % 1 frame = 64 bits; the length of col codes
frame = 9;  % the length of row codes; row codes is RS(9,11)

% generate binary source frame
Bin_Source = round(rand(M, frame));

% % convert the 1*9 bianry vector into 1*3 decimal vector
% Dec_Source = zeros(M,frame/3);
% for i = 1:length(Bin_Source)
%     for j = 1:3:7
%         binary_symbol = Bin_Source(i,j:j+2);
%         decimal_symbol = bi2de(binary_symbol,'left-msb');
%         Dec_Source(i,fix(j/3)+1) = decimal_symbol;
%     end
% end

% rs encoding which gives (9, 15) binary rs codes
rs_codes = RS_encoder(Bin_Source,3,5);

% rs decoding which
Bin_message = RS_decoder(rs_codes,3,5);



