rng(10)

trial = 1;
ms = [1];

Ostore = cell(numel(trial),numel(ms));
Pstore = cell(numel(trial),numel(ms));
Xstore = cell(numel(trial),numel(ms));
Ystore = cell(numel(trial),numel(ms));

for j=1:trial
for k=1:numel(ms)
    
m = ms(k);
n = 60-m;
lambda = 1.2;

X = randn(1,n)+1i*randn(1,n);
Y = X;
X = [X randn(1,m)+1i*randn(1,m)];
Y = [Y randn(1,m)+1i*randn(1,m)];


Xstore{j,k} = X;
Ystore{j,k} = Y;

X2 = X.*X;
Y2 = Y.*Y;

X3 = X.^3;
Y3 = Y.^3;


X4 = X.^4;
Y4 = Y.^4;

X5 = X.^4;
Y5 = Y.^4;

X6 = X.^4;
Y6 = Y.^4;
 
lambda = 1.5;
K      = 10;

cvx_begin sdp quiet

variable O(K,K) toeplitz hermitian
variable P(n+m,n+m) 


minimize sum(norms(O(1,2)*X - Y*P,2,1))/norm(X,'fro')+ sum(norms(O(1,3)*X2 - Y2*P,2,1))/norm(X2,'fro') + sum(norms(O(1,4)*X3 - Y3*P,2,1))/norm(X3,'fro')+  sum(norms(O(1,5)*X4 - Y4*P,2,1))/norm(X4,'fro') + ...
    sum(norms(O(1,6)*X5 - Y5*P,2,1))/norm(X5,'fro') + sum(norms(O(1,7)*X6 - Y6*P,2,1))/norm(X6,'fro')

subject to



O>=0
diag(O) == 1;


P(:)>=0

sum(P,1)==1
sum(P,2)==1

cvx_end

Ostore{j,k} = O;
Pstore{j,k} = P;
disp([j,k]);
end
end


%%
imagesc(Pstore{1});
colorbar


%%
indices = zeros(trial,numel(ms));
Mstore  = zeros(trial,numel(ms));
for i=1:trial
    for j=1:numel(ms)
        n = 60-ms(j);
        P = Pstore{i,j};
        [M,I] = max(P, [], 1);
        indices(i,j) = sum(I(1:n)==(1:n))/n;
        Mstore(i,j)  = mean(M(1:n));
    end
end
    