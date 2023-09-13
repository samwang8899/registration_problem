clear
clc

n = 10:10:80; %total number of points
d = 3;  %dimension of a point
noise_level  = 0.05;
ratio        = 0.3;
n_trials     = 12;
result       = zeros(n_trials,2,numel(n));
num_rand     = zeros(numel(n),1);

parfor i=1:numel(n)
    
    m = n(i)*ratio;
    [average_num] = average_intersection(n(i),m);
    res      = zeros(n_trials,2);
    for j=1:n_trials
        [num] = calculate_intersection(n(i),d,m,noise_level);
        res(j,:) = num;
    end
    result(:,:,i) = res;
    num_rand(i)   = average_num;
    disp("Number "+num2str(i)+" is done.");
end

disp("Experiment Done.");

%save('result.mat','result');
%save('avg_rand.mat','num_rand');
%%
aver_rand = num_rand;
aver_SDP  = zeros(numel(n),1);
for i=1:numel(n)
    aver_SDP(i) = mean(result(:,1,i));
end
aver_spec = zeros(numel(n),1);
for i=1:numel(n)
    aver_spec(i) = mean(result(:,2,i));
end


%%
plot(n,n*ratio,'DisplayName','Total num of good points')
hold on
plot(n,aver_SDP,'DisplayName','recovered by SDP+spectral')
plot(n,aver_spec,'DisplayName','recovered by spectral')
plot(n,aver_rand,'DisplayName','random')
hold off

lgd = legend;
lgd.NumColumns = 2;
