%====================================================================
% Exercise 5.20.
% This function generates the model and data for white noise 
% as well as an AR process, and runs the LMS algorithm.
%=====================================================================

function  LMS 
 
 figure 
L=10;%Dimension of the unknown vector
N=2500; %Number of Data
theta=randn(L,1);%Unknown parameter

IterNo=100;
wtot=zeros(N,IterNo);
MSE1=zeros(N,IterNo);
MSE2=zeros(N,IterNo);
noisevar=0.01;
X = randn(L,N);
inputvec = @(n) X(:,n); %Input process (white)

noise = randn(N,1)*sqrt(noisevar);

y = zeros(N,1);
y(1:N) = X(:,1:N)'*theta;
y = y + noise;

for It=1:IterNo
    xcorrel = randn(N+L-1,1);
 
xcorrel = xcorrel/std(xcorrel);

X = convmtx(xcorrel,L)';
X(:,1:L-1) = [];

inputvec = @(n) X(:,n);

noise = randn(N,1)*sqrt(noisevar);

y = zeros(N,1);
y(1:N) = X(:,1:N)'*theta;
y = y + noise;
w=zeros(L,1);
   mu=0.01; %Step size for the LMS
        for i=1:N
         
            e=y(i)-w'*inputvec(i);
            w=w+mu*e*inputvec(i);
            MSE1(i,It)=e^2;
        end
        
  
end
  

MSE2=zeros(N,IterNo);
 
for It=1:IterNo
  xcorrel = randn(N+L-1,1);
xcorrel = filter(1,[1 0.85],xcorrel); % AR process
xcorrel = xcorrel/std(xcorrel);

X = convmtx(xcorrel,L)';
X(:,1:L-1) = [];

inputvec = @(n) X(:,n);


inputvec = @(n) X(:,n);

noise = randn(N,1)*sqrt(noisevar);

y = zeros(N,1);
y(1:N) = X(:,1:N)'*theta;
y = y + noise;
w=zeros(L,1);
   mu=0.01;
        w=zeros(L,1);
         mu=0.01;%Small stepsize. Choose a large stepsize to obtain 
                  %a divergence scenario
        for i=1:N
        
            e=y(i)-w'*inputvec(i);
            w=w+mu*e*inputvec(i);
            MSE2(i,It)=e^2;
        end

end
MSEav1=sum(MSE1')/IterNo;
MSEav2=sum(MSE2')/IterNo;


plot(10*log10(MSEav1),'r');hold on
plot(10*log10(MSEav2),'k')
