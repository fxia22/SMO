sigama=2;
C=0.05;


%r=find(cancel(:,10)==1);

%r=find(y==0);
X=banana;
%X=X_new(r,:);
n=size(X,1);
for i=1:2
    Xstd(i)=std(X(:,i));
    if(Xstd(i)==0)
        return;
    end
    Xmean(i)=mean(X(:,i));
    X(:,i)= (X(:,i)-Xmean(i))/Xstd(i);
end
K = zeros(n,n); 
for i = 1:n
    for j = 1:n
       K(i,j) = exp(-(norm(X(i,:) - X(j,:)))/sigama);
        
       % K(i,j) = (X(i,:)*X(j,:)');
    end
end

[R,alpha] = SVDDmy(K,C,0.0000001);

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
plot(X(:,1),X(:,2),'.');
hold;
r=find(alpha>0);
plot(X(r,1),X(r,2),'+');
r=find(alpha==C);
plot(X(r,1),X(r,2),'*');

for i=1:650
   tt(i)=1;
   for j=1:n
       tt(i)=tt(i)-2*alpha(j)*exp(-(norm(test1(i,:) - X(j,:)))/sigama);
   end
    tt(i)=tt(i)+alpha'*K*alpha;

end
r=find(tt<=R);
plot(test1(r,1),test1(r,2),'*');