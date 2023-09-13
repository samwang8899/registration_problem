function [O,P] = cvx_subroutine(K, n, m, Xcell, Ycell)

cvx_begin sdp quiet
cvx_solver mosek
variable O(K,K) toeplitz hermitian
variable P(n+m,n+m) 

loss = 0;
for i=1:K-1
    loss = loss + sum(norms(O(1,(i+1))*Xcell{i} - Ycell{i}*P,2,1))/norm(Xcell{i},'fro');
end
minimize loss

subject to
O>=0
diag(O) == 1;
P(:)>=0
sum(P,1)==1
sum(P,2)==1
cvx_end

end