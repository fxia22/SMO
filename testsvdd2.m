data = importdata('parkinsons.data');
head = data.textdata(1,2:end);
numdata = data.data;

y = numdata(:,17);
n = size(y,1);

y(find(y==0)) = -1;
X = numdata(:,[1:16,18:end]);


K = zeros(n,n); 
for i = 1:n
    for j = 1:n
        K(i,j) = exp(-norm(X(i,:) - X(j,:))/100);
    end
end
[alpha,b] = svdd(K,y',0.20,0.00001);
