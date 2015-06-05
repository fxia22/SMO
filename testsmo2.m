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

[alpha,b] = smo(K,y',200,0.00001);
numa = 0;
numc = 0;
for i = 1:n
    x = X(i,:);
    k = zeros(1,n);
    for j = 1:n
        k(j) = exp(-norm(x - X(j,:))/100);
    end
    a = y'.*alpha*k';
    fprintf('true label %d, predicted label %d\n',y(i),sign(a - b));
    numa = numa + 1;
    if y(i) == sign(a-b)
        numc = numc + 1;
    end
end

fprintf('precision %f',numc/numa);