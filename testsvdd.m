sigma = 100;
C=0.15;
%parkinson
%data = importdata('parkinsons.data');
head = data.textdata(1,2:end);
numdata = data.data;
y = numdata(:,17);
y(find(y==0)) = -1;
X = numdata(find(y==1),[1:16,18:end]);
X_all = numdata(:,[1:16,18:end]);
%iris
%data = importdata('iris.data2');
%numdata = data;
%y = numdata(:,5);
%X = numdata((find(y==1)),1:4);
%X_all = numdata(:,1:4);
%r=find(cancel(:,10)==1);
%r=find(y==0);
%X=banana;
%X=X_new(r,:);
n=size(X,1);
%Xstd = zeros(n,1);
%Xmean = zeros(n,1);
%for i=1:2
%    Xstd(i)=std(X(:,i));
%    if(Xstd(i)==0)
%        continue;
%    end
%    Xmean(i)=mean(X(:,i));
%    X(:,i)= (X(:,i)-Xmean(i))/Xstd(i);
%end
K = zeros(n,n); 
for i = 1:n
    for j = 1:n
       K(i,j) = kernel(X(i,:), X(j,:), sigma);    
    end
end

[R,alpha] = SVDDmy(K,C,0.000000001);

X_ = X;
figure(1);
hold on;
[~,X_,~] = pca_compress(X,3);
plot3(X_(:,1),X_(:,2),X_(:,3),'.');
r=find(alpha>0);
plot3(X_(r,1),X_(r,2),X_(r,3),'r+');
r=find(alpha==C);
plot3(X_(r,1),X_(r,2),X_(r,3),'g*');
figure(2)
plot(alpha);

c = 0;
for i = 1:n
    for j = 1:n
        c = c + alpha(i)*alpha(j)*kernel(X(i,:), X(j,:), sigma);
    end
end

%now test X_all and y
y_pred = zeros(size(y));
m = size(y,1);
for i = 1:m
    d = kernel(X_all(i,:),X_all(i,:),sigma);
    for j = 1:n
        d = d-2*alpha(j)*kernel(X_all(i,:),X(j,:),sigma);
    end
    d = d + c;
    y_pred(i) = d < R;
end
y_pred(find(y_pred == 0)) = -1;
fp = sum((y-y_pred == -2));
fn = sum((y-y_pred == 2));
tp = sum((y+y_pred == 2));
tn = sum((y+y_pred == -2));
fprintf('tp:%d, tn:%d, fp:%d, fn:%d\n', tp,tn,fp,fn);
fprintf('precision:%f, recall:%f, accuracy:%f\n', tp/(tp+fp), tp/(tp+fn),(tp+tn)/(tp+fp+tn+fn));

