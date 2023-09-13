function [num] = average_intersection(n,m)

num_trials = 1000;
res        = zeros(num_trials,1);
for i=1:num_trials
    t1 = randsample(1:n,m);
    t2 = randsample(1:n,m);
    res(i) = numel(intersect(t1,t2));
end
num = mean(res);

end