data = importdata('iris.data2');
numdata = data;
y = numdata(:,5);
n = size(y,1);

X = numdata(:,1:4);

K = zeros(n,n);
for i = 1:n
    for j = 1:n
        K(i,j) = exp(-norm(X(i,:) - X(j,:))/10);
        %K(i,j) = X(i,:)*X(j,:)';
    end
end

[alpha,mu] = svdd(K,y',0.25,0.00001);
