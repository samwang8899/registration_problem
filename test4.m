n = 50;
m = 10;
lambda = 1.2;

X = randn(1,n)+1i*randn(1,n);
Y = X;
X = [X randn(1,m)+1i*randn(1,m)];
Y = [Y randn(1,m)+1i*randn(1,m)];


X2 = X.*X;
Y2 = Y.*Y;

X3 = X.^3;
Y3 = Y.^3;


X4 = X.^4;
Y4 = Y.^4;


%%
lambda = 1.5;
K      = 10;

cvx_begin sdp

variable O(K,K) toeplitz hermitian
variable P(n+m,n+m) 


minimize sum(norms(O(1,2)*X - Y*P,2,1))+ sum(norms(O(1,3)*X2 - Y2*P,2,1)) + sum(norms(O(1,4)*X3 - Y3*P,2,1))+  sum(norms(O(1,5)*X4 - Y4*P,2,1))

subject to



O>=0
diag(O) == 1;


P(:)>=0

sum(P,1)==1
sum(P,2)==1

cvx_end

%%
imagesc(P)
colorbar