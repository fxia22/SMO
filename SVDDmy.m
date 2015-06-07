function [alpha,mu] = SVDDmy(K, C, tol)
m=size(K);
alpha =zeros(m(1),1);
alpha =alpha+1/m(2);
ntp=m(1);
for i = 1:ntp
    error(i) =1-2/m(1) *sum(K(i,:));
end
iter=0;
while 1
    POS=find(alpha>0);
    MIN=min(error(POS));
     POS1=find(alpha<C);
    MAX=max(error(POS1));
  
    i1=find(error==MIN);
    i2=find(error== MAX);
    if(size(i1,2)>1)
        i1=i1(1);
    end
     if(size(i2,2)>1)
        i2=i2(1);
    end
    disp(num2str(size(i1)));
    disp(num2str(size(i2)));
    fprintf('%d   %d  %f  %f\n',i1,i2,MAX,MIN);
    if(MIN+tol>=MAX)
        break;
    end
    lamda=min([C-alpha(i2),alpha(i1),( error(i2)- error(i1))/2/(K(i1,i1)+K(i2,i2)-2*K(i1,i2))]);
    for i = 1:ntp
    error(i) =error(i)-2*lamda*(K(i2,i)-K(i1,i));
    end
    iter=iter+1;
    alpha(i2)=alpha(i2)+lamda;
    alpha(i1)=alpha(i1)-lamda;
    out(iter)=alpha'*diag(K)-alpha'*K*alpha;
     fprintf('%f %f',out(iter),lamda); 
    
end

    mu=0;
    
end