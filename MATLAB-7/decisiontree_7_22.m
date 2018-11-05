%-----------------------------------------------------------------
%  MATLAB code for Exercise 7.22
%  Decision Trees
%-----------------------------------------------------------------

clear
format compact
close all

% Generating the training date set
randn('seed',0)
m11=[0 3]'; m12=[11 -2]'; m21=[3 -2]'; m22=[7.5 4]'; m3=[7 2]';
S11=[.2 0; 0 2]; S12=[3 0; 0 0.5]; S21=[5 0; 0 0.5]; S22=[7 0; 0 0.5]; S3=[8 0; 0 0.5];
n_of_points_per_group=500;

X=[mvnrnd(m11',S11,n_of_points_per_group); mvnrnd(m12',S12,n_of_points_per_group); mvnrnd(m21',S21,n_of_points_per_group); mvnrnd(m22',S22,n_of_points_per_group); mvnrnd(m3',S3,n_of_points_per_group)]';
label=[ones(1,n_of_points_per_group) ones(1,n_of_points_per_group) 2*ones(1,n_of_points_per_group) 2*ones(1,n_of_points_per_group) 3*ones(1,n_of_points_per_group)];
[l,p]=size(X);
%Plot the training data set
figure; plot(X(1,label==1),X(2,label==1),'.b',X(1,label==2),X(2,label==2),'.r',X(1,label==3),X(2,label==3),'.g'); axis equal

% Generating the training date set
randn('seed',100)
n_of_points_per_group=500;

X_test=[mvnrnd(m11',S11,n_of_points_per_group); mvnrnd(m12',S12,n_of_points_per_group); mvnrnd(m21',S21,n_of_points_per_group); mvnrnd(m22',S22,n_of_points_per_group); mvnrnd(m3',S3,n_of_points_per_group)]';
label_test=[ones(1,n_of_points_per_group) ones(1,n_of_points_per_group) 2*ones(1,n_of_points_per_group) 2*ones(1,n_of_points_per_group) 3*ones(1,n_of_points_per_group)];
[l,p]=size(X_test);
%Plot the test data set
figure; plot(X_test(1,label==1),X_test(2,label==1),'.b',X_test(1,label==2),X_test(2,label==2),'.r',X_test(1,label==3),X_test(2,label==3),'.g'); axis equal


y=ordinal(label);   %Converting the 'label' to ordinal values
y_test=ordinal(label_test);   %Converting the 'label' to ordinal values
t = classregtree(X',y); %Creating the classification tree
view(t)                 %View the classification tree
label_tree = eval(t,X'); %Evaluate the performance of the decision tree

for k=0:1:20
k;
t2 = prune(t,'level',k); %Cut the decision tree at level k
label_tree = eval(t2,X_test'); %Evaluating the performance of the decision tree

% Computation of the probability of error
Pe(k+1)=0;
for i=1:p
    if(y_test(i)~=label_tree{i})
        Pe(k+1)=Pe(k+1)+1;
    end
end
Pe(k+1)=Pe(k+1)/p;
end
figure; plot(Pe)