function [precision, recall, accuracy] =  benchmarksvdd(X_all, y, sigma, C,iter)
precision = 0;
recall = 0 ;
accuracy = 0;
for i = 1:iter
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
%fprintf('tp:%d, tn:%d, fp:%d, fn:%d\n', tp,tn,fp,fn);
%fprintf('precision:%f, recall:%f, accuracy:%f\n', tp/(tp+fp), tp/(tp+fn),(tp+tn)/(tp+fp+tn+fn));

precision = precision + tp/(tp+fp);
recall = recall +  tp/(tp+fn);
accuracy =accuracy + (tp+tn)/(tp+fp+tn+fn);
end

precision = precision/iter;
recall = recall/iter;
accuracy = accuracy/iter;
end