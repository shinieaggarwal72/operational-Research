clc
clear all
format short

A = [3 -1 1 1 0 0;-1 2 0 0 1 0; -4 3 8 0 0 1];
b = [7; 6 ;10];
C = [-1 3 -3 0 0 0];

%% number of constraints and variables 
[m,n] = size(A);
num_var = nchoosek(n,m);
t = nchoosek(1:n,m);

%% construct basic solution
sol = [];
if n>=m
    for i = 1:num_var
        y = zeros(n,1);
        x = A(:,t(i,:))\b;
        if all(x>=0 & x~=Inf & x~=-Inf)
            y(t(i,:)) = x;
            sol = [sol y];
        end
    end
else
    error('Equations are more than variables');
end

%% objective function
Z = C*sol;

%% finding optimal value
[zmax, zidx] = max(Z);
bfs = sol(:,zidx);

%% print all solutions
optval = [bfs' zmax];
optbfs = array2table(optval);
optbfs.Properties.VariableNames(1:size(optbfs,2)) = {'x1', 'x2', 'x3', 's1', 's2', 's3', 'value of z'};
