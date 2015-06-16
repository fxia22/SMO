
for i = 1:10
sigma = 50;
C=0.1+0.02*i;
data = importdata('ecoli.csv');
y = data(:,end);
y(find(y==0)) = -1;
X_all = data(:,1:7);
N = size(y,1);

[precision, recall, accuracy] = benchmarksvdd(X_all,y,sigma,C,20);
fprintf('ecoli data, precision:%f, recall:%f, accuracy:%f\n',precision,recall,accuracy);
end