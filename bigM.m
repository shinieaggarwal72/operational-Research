clc
clear all
%% Example problem
% Min Z = 2*x1 + 8*x2
% such that 5*x1 + 10*x2 = 150
%           x1 <= 20
%           x2 >=14
%           x1, x2 >=0

%% input the parameters in matrix form
variables = {'x1', 'x2', 's1', 's2', 'A1', 'A2' 'z'};
cost = [-2 -8 0 0 -1000 -1000 0];
info = [5 10 0 0 1 0; 1 0 1 0 0 0 ; 0 1 0 -1 0 1];
b = [150; 20; 14];
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
ZCj = [ZjCj; a]


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
optimalBFS = array2table(finalBFS, 'VariableNames',{'x1','x2','s1','s2','A1', 'A2' 'z'})