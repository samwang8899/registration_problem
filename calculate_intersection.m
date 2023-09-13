function [num] = calculate_intersection(n,d,m,noise_level)

X = randn(n,d);
X = normr(X);

samps_good = sort(randsample(1:n, m));
samps_bad  = sort(setdiff(1:n, samps_good));


Y = zeros(n,d);
for i=1:m
    ind    = samps_good(i);
    point  = X(ind,:)+noise_level*randn(1,d);
    point  = point/norm(point,2);
    Y(ind,:) = point;
end

for i=1:(n-m)
    ind    = samps_bad(i);
    point  = randn(1,d);
    point  = point/norm(point,2);
    Y(ind,:) = point;
end

P = eye(n);
P = P(randperm(n),:);
Y = P*Y;

F = X*X';
G = Y*Y';

M = F.*G;

cvx_begin sdp quiet
cvx_solver mosek
cvx_precision high
variable Z(n,n) symmetric
maximize trace(M*Z)
Z>=0;
Z(:)>=0;
sum(Z,1)<=m;
trace(Z)==m;
cvx_end

[U1,~,~]=svd(Z);
[~,ind_rec1]=maxk(abs(U1(:,1)),m);
ind_rec1 = sort(ind_rec1);
common1 = numel(intersect(samps_good,ind_rec1));

[U2,~,~]=svd(M);
[~,ind_rec2]=maxk(abs(U2(:,1)),m);
ind_rec2 = sort(ind_rec2);
common2 = numel(intersect(samps_good,ind_rec2));

num = [common1, common2];

end