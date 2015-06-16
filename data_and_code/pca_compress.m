function [pcs, cprs_data, cprs_c] = pca_compress(data, num)
sz = size(data);
n = sz(1);
dim = sz(2);
ms = zeros(dim,1);
sdv = zeros(dim,1);

for i = 1:dim
    ms(i) = mean(data(:,i));
    sdv(i) = std(data(:,i));
    data(:,i) = data(:,i) - ms(i);
    data(:,i) = data(:,i)./sdv(i);
end
[U,V] = eig(data'*data);
V = diag(V);
sv = sum(V');
s = 0;
pcs = U(:,dim+1-num:dim);
cprs_data = data*pcs;
cprs_c = [ms,sdv];
end
