function [bin_message] = RS_decoder(codes,k,n)
% codes are (k,n) RS codes, whcih is a matrix
% k decimal message length
% n decimal code length
global M;

% convert the 64*15 binary RS codes into 64*5 decimal RS codes
Dec_Source = zeros(M,5);
for i = 1:length(codes)
    for j = 1:3:13
        binary_symbol = codes(i,j:j+2);
        decimal_symbol = bi2de(binary_symbol,'left-msb');
        Dec_Source(i,fix(j/3)+1) = decimal_symbol;
    end
end

% decoding (3,5) decimal RS codes get 64*3 decimal message
dec_message = zeros(64,k);
for i = 1:length(Dec_Source)
    msg_poly = gf(Dec_Source(i,:),3);
    msg_decimal = rsdec(msg_poly, n, k);
    dec_message(i,:) = msg_decimal.x;
end

% conver 64*3 decimal message into 64*9 binary mesage
bin_message = zeros(64,9);
for i = 1:length(dec_message)
    
    % get a 3*3 char array
    temp = dec2bin(dec_message(i,:),k);
    
    % convert 5*3 char array into 1*15 binary row vector
    index = 1;
    for j = 1:3
        for k = 1:3
            bin_message(i, index) = eval(temp(j,k));
            index = index + 1;
        end
    end
end

end

