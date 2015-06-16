sigma = 50;
C=0.20;
%parkinson
data = importdata('parkinsons.data');
head = data.textdata(1,2:end);
numdata = data.data;
y = numdata(:,17);
y(find(y==0)) = -1;
X = numdata(find(y==1),[1:16,18:end]);
X_all = numdata(:,[1:16,18:end]);
N = size(y,1);

 [precision, recall, accuracy] = benchmarksvdd(X_all,y,sigma,C,2);
 fprintf('parkinson data, precision:%f, recall:%f, accuracy:%f\n',precision,recall,accuracy);
 
 
 sigma = 50;
C=0.20;
 data = importdata('iris.data2');
 y = data(:,end);
 X_all = data(:,1:4);
 N = size(y,1);
 [precision, recall, accuracy] = benchmarksvdd(X_all,y,sigma,C,2);
 fprintf('iris data, precision:%f, recall:%f, accuracy:%f\n',precision,recall,accuracy);

 
 
 sigma = 50;
C=0.20;
 data = importdata('cancer.csv');
 y = data(:,end);
 X_all = data(:,1:9);
 N = size(y,1);
 
  [precision, recall, accuracy] = benchmarksvdd(X_all,y,sigma,C,2);
 fprintf('cancer data, precision:%f, recall:%f, accuracy:%f\n',precision,recall,accuracy);


 
sigma = 50;
C=0.20;
data = importdata('ecoli.csv');
y = data(:,end);
y(find(y==0)) = -1;
X_all = data(:,1:7);
N = size(y,1);

[precision, recall, accuracy] = benchmarksvdd(X_all,y,sigma,C,2);
fprintf('ecoli data, precision:%f, recall:%f, accuracy:%f\n',precision,recall,accuracy);

 
%normalize X
% Xstd = zeros(N,1);
% Xmean = zeros(N,1);
% for i=1:size(X_all,2)
%     Xstd(i)=std(X_all(:,i));
%     if(Xstd(i)==0)
%         continue;
%     end
%     Xmean(i)=mean(X_all(:,i));
%     X_all(:,i)= (X_all(:,i)-Xmean(i))/Xstd(i);
% end




