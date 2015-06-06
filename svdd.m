function [alpha,mu] = svdd(K, y, C, tol)
global SVDD;

ntp = size(K,1);
%recompute C
%initialize
ii0 = find(y == 1); % positive example
i0 = ii0(1);
rnd = rand(ntp,1);
rnd = rnd/sum(rnd);
alpha_init = rnd;
mu_init = -(K(1,1) - alpha_init(1)*K(1,1)-alpha_init'*K(:,1));

%Inicializando las variables
SVDD.epsilon = 10^(-6); SVDD.tolerance = tol;
SVDD.C = C;
SVDD.alpha = alpha_init; SVDD.mu = mu_init;
SVDD.ntp = ntp; %number of training points

%CACHES:
SVDD.Kcache = K; %kernel evaluations
for i = 1:SVDD.ntp
    SVDD.error(i) = K(i,i) - SVDD.alpha(i)*K(i,i) - SVDD.alpha'*K(:,i)+SVDD.mu;
end
numChanged = 0; examineAll = 1;

%When all data were examined and no changes done the loop reachs its 
%end. Otherwise, loops with all data and likely support vector are 
%alternated until all support vector be found.
iter = 0;
while ((numChanged > 0) || examineAll)
    numChanged = 0;
    if examineAll
        %Loop sobre todos los puntos
        for i = 1:ntp
            numChanged = numChanged + examineExample(i);
            fprintf('all-set, iter: %d i:%d, pairs changed %d\n', iter, i, numChanged);
        end; 
        iter = iter + 1;
    else
        %Loop sobre KKT points
        for i = 1:ntp
            %Solo los puntos que violan las condiciones KKT
            if (SVDD.alpha(i)>SVDD.epsilon) && (SVDD.alpha(i)<(SVDD.C-SVDD.epsilon))
                numChanged = numChanged + examineExample(i);
                fprintf('non-bound, iter: %d i:%d, pairs changed %d\n', iter, i, numChanged);
            end;
        end;
        iter = iter + 1;
    end;
    
    if (examineAll)
        examineAll = 0;
    elseif (numChanged == 0)
        examineAll = 1;
    end;
    fprintf('iteration number %d\n',iter);
end;
alpha = SVDD.alpha';
alpha(SVDD.alpha < SVDD.epsilon) = 0;
alpha(SVDD.alpha > C-SVDD.epsilon) = C;
mu = -SVDD.mu;
return;

function RESULT = examineExample(i2)
%First heuristic selects i2 and asks to examineExample to find a
%second point (i1) in order to do an optimization step with two 
%Lagrange multipliers
global SVDD;
alpha2 = SVDD.alpha(i2);
e2 = SVDD.error(i2);
% r2 < 0 if point i2 is placed between margin (-1)-(+1)
% Otherwise r2 is > 0. r2 = f2*y2-1
r2 = e2;
%KKT conditions:
% r2>0 and alpha2==0 (well classified)
% r2==0 and 0% r2<0 and alpha2==C (support vectors between margins)
%
% Test the KKT conditions for the current i2 point. 
%
% If a point is well classified its alpha must be 0 or if
% it is out of its margin its alpha must be C. If it is at margin
% its alpha must be between 0%take action only if i2 violates Karush-Kuhn-Tucker conditions
if ((r2 < -SVDD.tolerance) && (alpha2 < (SVDD.C-SVDD.epsilon))) || ((r2 > SVDD.tolerance) && (alpha2 > SVDD.epsilon))
    % If it doens't violate KKT conditions then exit, otherwise continue.

    %Try i2 by three ways; if successful, then immediately return 1; 
    RESULT = 1;
    % First the routine tries to find an i1 lagrange multiplier that
    % maximizes the measure |E1-E2|. As large this value is as bigger 
    % the dual objective function becames.
    % In this first test, only support vectors will be tested.

    POS = find((SVDD.alpha > SVDD.epsilon) & (SVDD.alpha < (SVDD.C-SVDD.epsilon)));
    [MAX,i1] = max(abs(e2 - SVDD.error(POS)));
    if ~isempty(i1)
        if takeStep(i1, i2, e2), return;
        end;
    end;
    %The second heuristic choose any Lagrange Multiplier that is a SV and tries to optimize
    for i1 = randperm(SVDD.ntp)
        if (SVDD.alpha(i1) > SVDD.epsilon) && (SVDD.alpha(i1) < (SVDD.C-SVDD.epsilon))
        %if a good i1 is found, optimise
            if takeStep(i1, i2, e2), return;
            end;
        end
    end
    %if both heuristc above fail, iterate over all data set 
    for i1 = randperm(SVDD.ntp)
        if ~((SVDD.alpha(i1) > SVDD.epsilon) && (SVDD.alpha(i1) < (SVDD.C-SVDD.epsilon)))
            if takeStep(i1, i2, e2), return;
            end;
        end
    end;
end; 
%no progress possible
RESULT = 0;
return;


function RESULT = takeStep(i1, i2, e2)
% for a pair of alpha indexes, verify if it is possible to execute
% the optimisation described by Platt.

global SVDD;
RESULT = 0;
if (i1 == i2), return; 
end;

% compute upper and lower constraints, L and H, on multiplier a2
alpha1 = SVDD.alpha(i1); alpha2 = SVDD.alpha(i2);
C = SVDD.C; K = SVDD.Kcache;
mu = SVDD.mu;
L = max(0, alpha1+alpha2-C); H = min(C, alpha1+alpha2);

if (L == H)
    return;
end;

e1 = SVDD.error(i1);

a = -2*K(i1,i2)+K(i1,i1)+K(i2,i2);
b = -K(i1,i1)+K(i2,i2)+2*(alpha1+alpha2)*(K(i1,i1)-K(i1,i2));
for i = 1:SVDD.ntp
    if (i~=i1)&&(i~=i2)
        b = b+SVDD.alpha(i)*(K(i1,i)-K(i2,i));
    end
end

clip_alpha1 = 0;
clip_alpha2 = 0;
alpha2new = -b/(2*a);
if alpha2new>H
    alpha2new = H;
    clip_alpha2 = 1;
end

if alpha2new<L
    alpha2new = L;
    clip_alpha2 = 1;
end

alpha1new = alpha1+alpha2-alpha2new;
if alpha1new>H
    alpha1new = H;
    clip_alpha1 = 1;
end

if alpha1new<L
    alpha1new = L;
    clip_alpha1 = 1;
end

mu1 = (alpha1new - alpha1)*K(i1,i1) + (alpha2new - alpha2)*K(1,2) + mu;
mu2 = (alpha1new - alpha1)*K(i2,i1) + (alpha2new - alpha2)*K(2,2) + mu;

if clip_alpha1 == 1
    munew = mu1;
elseif clip_alpha2 == 1
    munew = mu2;
else
    munew = (mu1+mu2)/2;
end

if (abs(alpha2new-alpha2) < SVDD.epsilon*(alpha2new+alpha2+SVDD.epsilon))
    return;
end;

% update error cache using new Lagrange multipliers
%SMO.error = SMO.error + w1*K(:,i1) + w2*K(:,i2) + bold - SMO.bias;
%SMO.error(i1) = 0.0; SMO.error(i2) = 0.0;
% update vector of Lagrange multipliers
SVDD.alpha(i1) = alpha1new; SVDD.alpha(i2) = alpha2new;
SVDD.mu = munew;
for i = 1:SVDD.ntp
    SVDD.error(i) = K(i,i) - SVDD.alpha(i)*K(i,i) - SVDD.alpha'*K(:,i)+SVDD.mu;
end
%report progress made
RESULT = 1;
return;