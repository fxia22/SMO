data = importdata('parkinsons.data');
r=find(data.data(:,17)==1);
X=data.data(r,1:16);
n=size(X,1);
K = zeros(n,n); 
for i=1:16
    Xstd(i)=std(X(:,i));
    if(Xstd(i)==0)
        return;
    end
    Xmean(i)=mean(X(:,i));
    X(:,i)= (X(:,i)-Xmean(i))/Xstd(i);
end
for i = 1:n
    for j = 1:n
        K(i,j) = exp(-(X(i,:) - X(j,:))*(X(i,:) - X(j,:))'/10);
        
       % K(i,j) = (X(i,:)*X(j,:)');
    end
end
C=0.05;
[alpha,mu] = SVDDmy(K,C,0.0000001);
R=0;
iter=0;
for i=1:n
    if(alpha(i)>0&&alpha(i)<C)
        R=R+K(i,i)-2*alpha'*K(:,i)+alpha'*K*alpha;
        iter=iter+1;
    end
end
R=R/iter;
cor1=0;
cor2=0;
for i=1:n
    if(alpha(i)==0)
      if(K(i,i)-2*alpha'*K(:,i)+alpha'*K*alpha<=R)  
          cor1=cor1+1;
      end
    end
    if(alpha(i)==C)
        tt=K(i,i)-2*alpha'*K(:,i)+alpha'*K*alpha;
      if(K(i,i)-2*alpha'*K(:,i)+alpha'*K*alpha>R)  
          cor2=cor2+1;
      end
    end
    if(alpha(i)<C&&alpha(i)>0)
        tt=K(i,i)-2*alpha'*K(:,i)+alpha'*K*alpha;
      if(K(i,i)-2*alpha'*K(:,i)+alpha'*K*alpha<=R)  
          cor1=cor1+1;
      end
    end
end
r=find(alpha<C);
cor1/size(r,1)
cor2/(n-size(r,1))
figure;
plot3(X(:,1),X(:,2),X(:,3),'.');
hold;
r=find(alpha>0);
plot3(X(r,1),X(r,2),X(r,3),'+');
r=find(alpha==C);
plot3(X(r,1),X(r,2),X(r,3),'*');
