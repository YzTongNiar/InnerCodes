% The function generates a LDPC generating matrix, 
% given size (M*N) & ones per column
function [H] = makeLdpc(M, N, onePerCol)

% calculate the number of ones per row
onePerRow = (N/M)*onePerCol;
for i = 1:N
    onesInCol(:,i) = randperm(M)';
end

% generate non-zero elements index
r = reshape(onesInCol(1:onePerCol,:),N*onePerCol,1);
tmp = repmat(1:N,onePerCol,1);% check
c = reshape(tmp,N*onePerCol,1);

% Row index
[r, ix] = sort(r);

% generate Col index according to Row index
for i = 1:N*onePerCol
    cSort(i,:) = c(ix(i));
end

% generate new Row index
tmp = repmat(1:M, onePerRow, 1);
r = reshape(tmp, N*onePerCol, 1);

% generate Sparsity Matrix

% eliminate consecutive ones
S = and(sparse(r, cSort, 1, M, N), ones(M, N)); % check
H = full(S); %check 

% check whether exits a row has only ones or no ones
for i = 1:M
    n = randperm(N);
    % if there is no 1, add two 1s
%     if length(find(r == i)) == 0
    if isempty(find(r==i,1))
        H(i, n(1)) = 1;
        H(i, n(2)) = 1;
    % if there is only one 1, add an 1
    elseif length(find(r==i)) == i
            H(i, n(i)) = 1;
    end
end

% elimibate four 4-cycle
for i = 1:M
    % find Row-Col Pair
    for j = (i+1):M
        w = and(H(i,:),H(j,:));
        c1 = find(w);
        lc = length(c1);
        if lc > 1
            % if fing four-cycle, fill it with 0 to skip consecutive 1s
            if length(find(H(i,:))) < length(find(H(j,:)))
                % repeat the process
                for cc = 1:lc-1
                    H(j, c1(cc)) = 0;
                end
            else
                for cc = 1:lc-1
                    H(i, c1(cc)) = 0;
                end
            end
        end
    end
end

end
