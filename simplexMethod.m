clc
clear all
%% input the parameters in matrix form
variables = {'x1', 'x2', 'x3', 's1', 's2', 's3', 'z'};
cost = [-1 3 -2 0 0 0 0];
info = [3 -1 2 1 0 0; -2 4 0 0 1 0; -4 3 8 0 0 1];
b = [7; 12 ; 10];
s = eye(size(info,1));
a = [info b];

%% find the basic variables
bv = [];
for j = 1: size(s,2)
    for i = 1:size(a,2)
        if isequal(a(:,i),s(:,j))
            bv = [bv i];
        end
    end
end

%% find Zj-Cj
B = a(:,bv);
a = inv(B)*a;
ZjCj = cost(bv)*a - cost;
ZCj = [ZjCj; a];

%% loop until optima obtained
run = true;
while run
    ZC = ZjCj(:,1:end-1);
    if min(ZC)<0
        fprintf('Current solution is not optimal\n');
        [val,pvt_col] = min(ZC);
        fprintf('Entering column: %d\n', pvt_col);
        sol = a(:,end);
        col = a(:,pvt_col);
        ratio = sol./col;
        ratio(col<=0) = inf;
        [val1, pvt_row] = min(ratio);
        fprintf('Leaving row: %d\n', pvt_row);
        bv(pvt_row) = pvt_col;
        B = a(:,bv);
        a = inv(B)*a;
        ZjCj = cost(bv)*a - cost;
    else
        run = false;
        fprintf('Current solution is optimal\n');
    end
end

%% print solution
finalBFS = zeros(1,size(a,2));
finalBFS(bv) = a(:,end);
finalBFS(end) = -sum(finalBFS.*cost);
optimalBFS = array2table(finalBFS, 'VariableNames',{'x1','x2','x3','s1','s2', 's3', 'z'})