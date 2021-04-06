% The function generates the parity check matrix

% The iunputs are:
% dSource: data source
% H: LDPC generate Matrix
% c: parity check bits

function [c, newH] = test(dSource, H)

% give the size of generate matrix
[M, N] = size(H);

% generate a new matrix F, for L U decomposition
F = H;

% L, U matrix
L = zeros(M, N - M);
U = zeros(M, N - M);

% rearrange M*(N-M) matrix
for i = 1:M
    % diagonal non-zero entires
    [r, c] = find(F(:, i:end));
    colWeight = sum(F(:, i:end), 1) - 1;
    rowWeight = sum(F(i, :), 2) - 1;
    % non-zero entires index
    rowIndex = find(r == i);
    % minimum product
    [x, ix] = min(colWeight(c(rowIndex))*rowWeight);
    % according to the index rearrange F
    chosenCol = c(rowIndex(ix)) + (i - 1);
    % H, F rearrange
    tmp1 = F(:, i);
    tmp2 = H(:, i);
    F(:, i) = F(:, chosenCol);
    H(:, i) = H(:, chosenCol);
    F(:, chosenCol) = tmp1;
    H(:, chosenCol) = tmp2;
    % fill the L, U matrix by column
    L(i:end, i) = F(i:end, i);
    U(1:i, i) = F(1:i, i);
    if i < M           
         % in the i-th column, find the index of next non-zero entry
        [r2, c2] = find(F((i + 1):end, i));          
        % insert a row
        F((i + r2), :) = mod(F((i + r2), :) + repmat(F(i, :), length(r2), 1), 2);
    end
end

% source code z
z = mod(H(:, (N - M) + 1:end)*dSource, 2);

% Parity Check Bit
c = mod(U\(L\z), 2); 

% return parity check matrix 
newH = H;
end

