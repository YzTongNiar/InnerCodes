function [bin_message] = RS_dec2(codes,k,n)
% codes are (k,n) RS codes, whcih is a vector
% k decimal message length
% n decimal code length

% convert the 1*15 binary RS codes into 1*5 decimal RS codes
Dec_Source = zeros(1,5);
for j = 1:3:13
    binary_symbol = codes(j:j+2);
    decimal_symbol = bi2de(binary_symbol,'left-msb');
    Dec_Source(fix(j/3)+1) = decimal_symbol;
end

% decoding (3,5) decimal RS codes get 1*3 decimal message
msg_poly = gf(Dec_Source,3);
msg_decimal = rsdec(msg_poly, n, k);
dec_message = msg_decimal.x;

% conver 1*3 decimal message into 1*9 binary mesage
bin_message = zeros(1,9);
% get a 3*3 char array
temp = dec2bin(dec_message,k);
    
% convert 3*3 char array into 1*9 binary row vector
index = 1;
for j = 1:3
    for k = 1:3
        bin_message(index) = eval(temp(j,k));
        index = index + 1;
    end
end
end

