function result =  kernel(x,y,sigma)
result = exp(-(norm(x(:) - y(:)))/sigma);
end
