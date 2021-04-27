% Belief Propagation Decoding under BEC
% The function gives the decoding col vector

% The inputs are:
% rx: received col vector
% H: LDPC generate matrix
% del: erasure rate
% iteration: iteration number

function vHat = BPBEC(rx, H, del, iteration)
[M N] = size(H);
% prior probability
Lci = (-4*rx./del)';
% initialization
Lrji = zeros(M, N);
Pibetaij = zeros(M, N);
% L(ci) correlates with H
Lqij = H.*repmat(Lci, M, 1);
% get non-zero entires
[r, c] = find(H);
% iteration
for n = 1:iteration
   % sign, magnitude of L(qij) 
   alphaij = sign(Lqij);   
   betaij = abs(Lqij);
   for l = 1:length(r)
      Pibetaij(r(l), c(l)) = log((exp(betaij(r(l), c(l))) + 1)/(exp(betaij(r(l), c(l))) - 1));
   end
   for i = 1:M
      % Column Non-zero Entires
      c1 = find(H(i, :));
      % Pi(betaij) Summation         
      for k = 1:length(c1)
         sumOfPibetaij = 0;
         prodOfalphaij = 1;
         % Pi(betaij)\c1(k) summation
         sumOfPibetaij = sum(Pibetaij(i, c1)) - Pibetaij(i, c1(k));
         % calculating Pi(sum(Pi(betaij))) to avoid x/0
         if sumOfPibetaij < 1e-20
            sumOfPibetaij = 1e-10;
         end         
         PiSumOfPibetaij = log((exp(sumOfPibetaij) + 1)/(exp(sumOfPibetaij) - 1));
         % profuct alphaij\c1(k) 
         prodOfalphaij = prod(alphaij(i, c1))*alphaij(i, c1(k));
         % update L(rji)
         Lrji(i, c1(k)) = prodOfalphaij*PiSumOfPibetaij;
      end
   end
   for j = 1:N
      % row non-zero entires
      r1 = find(H(:, j));
      for k = 1:length(r1)        
         % use sum(L(rij)\r1(k)) to update L(qij)
         Lqij(r1(k), j) = Lci(j) + sum(Lrji(r1, j)) - Lrji(r1(k), j);
      end
      LQi = Lci(j) + sum(Lrji(r1, j));
      
      % judge L(Qi)
      if LQi < 0
         vHat(j) = 1;
      else
         vHat(j) = 0;
      end                
   end
end
end


