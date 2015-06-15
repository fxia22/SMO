function [R,alpha] = SVDDmy(K, C, tol)
m=size(K);     %获取元素个数
alpha =rand(m(1),1);
alpha =alpha/sum(alpha);  %初始化alpha
ntp=m(1);
error=zeros(ntp,1);
for i = 1:ntp
    error(i) =K(i,i)-2*alpha'*K(i,:)';       %计算初始的error
end
while 1
    POS1=find(alpha>0);          
    MIN=min(error(POS1));           %寻找能减少的alpha中error最小的
     POS2=find(alpha<C);           
    MAX=max(error(POS2));         %寻找能增加的alpha中error最大的
    if(MIN>MAX)
        break;
    end
    i1=find(error==MIN);
    i2=find(error== MAX);
    if(size(i1,1)>1)              %若找到多个取第一个
        i1=i1(1);
    end
     if(size(i2,1)>1)
        i2=i2(1);
    end
    disp(num2str(size(i1)));
    disp(num2str(size(i2)));     
    fprintf('%d   %d  %f  %f\n',i1,i2,MAX,MIN);
    lamda=min([C-alpha(i2),alpha(i1),( error(i2)- error(i1))/2/(K(i1,i1)+K(i2,i2)-2*K(i1,i2))]);        %计算λ
    for i = 1:ntp
    error(i) =error(i)-2*lamda*(K(i2,i)-K(i1,i));              %迭代更新error
    end
    alpha(i2)=alpha(i2)+lamda;
    alpha(i1)=alpha(i1)-lamda;
     if(lamda<tol)
        break;
    end
end
R=0;
iter=0;
for i=1:ntp
    if(alpha(i)>0&&alpha(i)<C)
        R=R+K(i,i)-2*alpha'*K(:,i)+alpha'*K*alpha;          %利用支持向量计算R
        iter=iter+1;
    end
end
R=R/iter;
    
end