%Started 14/03/2013
%Ended   14/03/2013
%
%This function solves the optimization problem
%min_{a,b}    1/N �(y_n - f(x_n))^2 + �/2 �� a_n a_m �(x_n,x_m)
%where  f(x) = � a_n �(x_n,x) + b
%
%--------------------------------------
%Inputs
%X:               d x N matrix containing the N training points 
%                 x_1, x_2, ..., x_N
%y:               N x 1 vector containing the N training points 
%                 y_1, y_2, ..., y_N
%params           a matrix containg the problem parameters, i.e., �
%kernel_type      the type of the kernel. this is passed to the kappa
%                 function
%kernel_params    the parameters used to compute the kernel function. These
%                 are passed to the kappa function
%--------------------------------------
%Outputs
%sol              (N+1) x 1 vector containing the parameters a_n and the
%                 bias b (at the last place).



function sol = kernel_regression_l2_l2_biased(X, y, params, kernel_type, kernel_params)

lambda = params(1);
%build kernel matrix
[d,N] = size(X);
% for n=1:N
%     for m=1:N
%         K(n,m) = kappa(X(:,n), X(:,m), kernel_type, kernel_params);
%     end;
% end;
if strcmp(kernel_type, 'gaus')
    par = kernel_params;
    norms=zeros(N,N);
    for i=1:N
        T = bsxfun(@minus,X,X(:,i));
        norms(i,:) = sum(T.^2,1);
    end;
    K(:,:) = exp(-norms./(par^2));
elseif strcmp(kernel_type, 'gaus_c')
    par = kernel_params;
    norms=zeros(N,N);
    for i=1:N
        T = bsxfun(@minus,X,conj(X(:,i)));
        norms(i,:) = sum(T.^2,2);
    end;
    K(:,:) = 2*real(exp(-norms./(par^2)));
else
    K = zeros(N,N);
    for i=1:N
        for j=1:N
            K(i,j) = kappa(x(i,:), x(j,:), kernel_type, kernel_params);
        end;
    end;
end;

% A = [ (lambda*K + 2/N*K*transpose(K))    2/N*K*ones(N,1);    
%       2/N*ones(1,N)*transpose(K)  2];
% c = [2/N*K*y;
%      2/N*transpose(y)*ones(N,1)];
%Solve A*x=c
% sol = pinv(A)*c;

I = eye(N);
A = [ (lambda*I + 2/N*K)    2/N*ones(N,1);    
      2/N*ones(1,N)*K  2];
c = [2/N*y;
     2/N*transpose(y)*ones(N,1)]; 
%Solve A*x=c
sol = A\c;

