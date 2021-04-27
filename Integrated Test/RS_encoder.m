function [bin_rs_codes] = RS_encoder(Bin_Source, k, n)
%Source: binary source
%k: frame length
%n: code length
%rs_codes: RS codes in binary

% declare global variable
global M

% convert the 64*9 bianry source into 64*3 decimal vector
Dec_Source = zeros(M,3);
for i = 1:length(Bin_Source)
    for j = 1:3:7
        binary_symbol = Bin_Source(i,j:j+2);
        decimal_symbol = bi2de(binary_symbol,'left-msb');
        Dec_Source(i,fix(j/3)+1) = decimal_symbol;
    end
end


% rs encoding which gives decimal RS codes
rs_codes = zeros(M,n);
for i = 1:length(Dec_Source)
    % convert the decimal symbol into gf poly
    msg = gf(Dec_Source(i,:),k);
    % rs encoding
    rs_symbol = rsenc(msg, n, k);
    rs_codes(i,:) = rs_symbol.x;
end

bin_rs_codes = zeros(64,15);
% convert the decimal rs codes into binary rs codes

for i = 1:length(rs_codes)
    
    % get a 5*3 char array
    temp = dec2bin(rs_codes(i,:),k);
    
    % convert 5*3 char array into 1*15 binary row vector
    index = 1;
    for j = 1:5
        for k = 1:3
            bin_rs_codes(i, index) = eval(temp(j,k));
            index = index + 1;
        end
    end
end
end