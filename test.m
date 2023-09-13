n = 20;
A = randn(n);
B = randn(n);
P = eye(n);
P = P(randperm(n),:);

v1 = sum(sum((P*A*A'*P').*(B*B')));
v2 = sum(sum((P*A*A').*(B*B'*P)));

v1-v2