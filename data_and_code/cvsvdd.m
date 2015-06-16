sigma = 50;
C=0.20;
%parkinson
%data = importdata('parkinsons.data');
%head = data.textdata(1,2:end);
%numdata = data.data;
%y = numdata(:,17);
%y(find(y==0)) = -1;
%X = numdata(find(y==1),[1:16,18:end]);
%X_all = numdata(:,[1:16,18:end]);
%N = size(y,1);


 data = importdata('iris.data2');
 y = data(:,end);
 X_all = data(:,1:4);
 N = size(y,1);
 
%  data = importdata('cancer.csv');
%  y = data(:,end);
%  X_all = data(:,1:9);
%  N = size(y,1);

%data = importdata('ecoli.csv');
%y = data(:,end);
%y(find(y==0)) = -1;
%X_all = data(:,1:7);
%N = size(y,1);

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


train_idx = randsample(find(y==1), floor(2/3*sum((y==1))));
full_idx = [1:size(y,1)];
test_idx = full_idx(~ismember(full_idx,train_idx));
X = X_all(train_idx,:);
n=size(X,1);


K = zeros(n,n); 
for i = 1:n
    for j = 1:n
       K(i,j) = kernel(X(i,:), X(j,:), sigma);    
    end
end

[R,alpha] = SVDDmy(K,C,0.000001);

%X_ = X;
% figure(1);
% hold on;
% [~,X_,~] = pca_compress(X,3);
% plot3(X_(:,1),X_(:,2),X_(:,3),'.');
% r=find(alpha>0);
% plot3(X_(r,1),X_(r,2),X_(r,3),'r+');
% r=find(alpha==C);
% plot3(X_(r,1),X_(r,2),X_(r,3),'g*');
% figure(2)
% plot(alpha);

c = 0;
for i = 1:n
    for j = 1:n
        c = c + alpha(i)*alpha(j)*kernel(X(i,:), X(j,:), sigma);
    end
end

X_test = X_all(test_idx,:);
y_test = y(test_idx,:);
%now test X_all and y
y_pred = zeros(size(y_test));
m = size(y_test,1);
for i = 1:m
    d = kernel(X_test(i,:),X_test(i,:),sigma);
    for j = 1:n
        d = d-2*alpha(j)*kernel(X_test(i,:),X(j,:),sigma);
    end
    d = d + c;
    y_pred(i) = d < R;
end
y_pred(find(y_pred == 0)) = -1;
fp = sum((y_test-y_pred == -2));
fn = sum((y_test-y_pred == 2));
tp = sum((y_test+y_pred == 2));
tn = sum((y_test+y_pred == -2));
fprintf('tp:%d, tn:%d, fp:%d, fn:%d\n', tp,tn,fp,fn);
fprintf('precision:%f, recall:%f, accuracy:%f\n', tp/(tp+fp), tp/(tp+fn),(tp+tn)/(tp+fp+tn+fn));

