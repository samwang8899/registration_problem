rng(10)

%trial   = 100;
%moments = 1:12;
%ms      = [1,3,5,10,15];

trial   = 2;
moments = 5:6;
ms      = [1,3];

Ostore = cell(trial,numel(ms),numel(moments));
Pstore = cell(trial,numel(ms),numel(moments));
Xstore = cell(trial,numel(ms));
Ystore = cell(trial,numel(ms));


for ii=1:trial
    for jj=1:numel(ms)
        
        m = ms(jj);
        n = 60-m;
        X = randn(1,n)+1i*randn(1,n);
        Y = X;
        X = [X randn(1,m)+1i*randn(1,m)];
        Y = [Y randn(1,m)+1i*randn(1,m)];
        %Xstore{ii,jj} = X;
        %Ystore{ii,jj} = Y;
        
        parfor kk=1:numel(moments)
            
            order = moments(kk);
            Xcell = cell(order,1);
            Ycell = cell(order,1);
            for i=1:order
                Xcell{i} = X.^i;
                Ycell{i} = Y.^i;
            end
            K     = order+1;
            [O,P] = cvx_subroutine(K, n, m, Xcell, Ycell);
            Ostore{ii,jj,kk} = O;
            Pstore{ii,jj,kk} = P;
            disp([ii, jj, kk]);
            
        end
    end
end



%%
indices = zeros(trial,numel(ms),numel(moments));
Mstore  = zeros(trial,numel(ms),numel(moments));
for ii=1:trial
    for jj=1:numel(ms)
        for kk=1:numel(moments)
            n = 60-ms(jj);
            P = Pstore{ii,jj,kk};
            [M,I] = max(P, [], 1);
            indices(ii,jj,kk) = sum(I(1:n)==(1:n))/n;
            Mstore(ii,jj,kk)  = mean(M(1:n));
        end
    end
end
    


%%
imagesc(Pstore{1,1})
colorbar