function [R,alpha] = SVDDmy(K, C, tol)
m=size(K);     %??????
alpha =ones(m(1),1);
alpha =alpha/sum(alpha);  %???alpha
ntp=m(1);
error=zeros(ntp,1);
for i = 1:ntp
    error(i) =K(i,i)-2*alpha'*K(i,:)';       %?????error
end
while 1
    POS1=find(alpha>0);          
    MIN=min(error(POS1));           %??????alpha?error???
     POS2=find(alpha<C);           
    MAX=max(error(POS2));         %??????alpha?error???
    if(MIN+tol>MAX)
        break;
    end
    i1=find(error(POS1)==MIN);
    i2=find(error(POS2)== MAX);
    if(size(i1,1)>1)              %?????????
        i1=i1(size(i1,1));
    end
     if(size(i2,1)>1)
        i2=i2(size(i2,1));
     end  
     i1=POS1(i1);
      i2=POS2(i2);
    fprintf('%d   %d  %f  %f\n',i1,i2,MAX,MIN);
  disp([C-alpha(i2),alpha(i1),( error(i2)- error(i1))/2/(K(i1,i1)+K(i2,i2)-2*K(i1,i2))]);

    lamda=min([C-alpha(i2),alpha(i1),( error(i2)- error(i1))/2/(K(i1,i1)+K(i2,i2)-2*K(i1,i2))]);        %???
    for i = 1:ntp
    error(i) =error(i)-2*lamda*(K(i2,i)-K(i1,i));              %????error
    end
    alpha(i2)=alpha(i2)+lamda;
    alpha(i1)=alpha(i1)-lamda;
   
end
R=0;
iter=0;
for i=1:ntp
    if(alpha(i)>0&&alpha(i)<C)
        R=R+K(i,i)-2*alpha'*K(:,i)+alpha'*K*alpha;          %????????R
        iter=iter+1;
    end
end
R=R/iter;
    
end