clc
clear all

%% Example problem:
% cost matrix:
%   2   10  4   5
%   6   12  8   11
%   3   9   5   7

% avalibility:
%   12  25  20

% demand:
%   25  10  15  5

%% input 
c = [2 10 4 5; 6 12 8 11; 3 9 5 7];
[m,n] = size(c);
a = [12 25 20];
b = [25 10 15 5];
z = 0;

%% Make cost matrix balanced
if sum(a)==sum(b)
    fprintf('Given transportation problem is balanced\n');
else
    fprintf('Given transportation problem is unbalanced\n');
    if sum(a) < sum(b)
        c(end+1,:) = zeros(1,length(b));
        a(end+1) = sum(b) - sum(a);
    else
        c(:,end+1) = zeros(length(a),1);
        b(end+1) = sum(a) - sum(b);
    end
end

%% Loop until all supply or demand is exhausted
x = zeros(m,n);
initialC = c;
for i = 1: m
    for j = 1:n
        cpq = min(c(:));
        if cpq == inf
            break
        end
        [p1,q1] = find(cpq == c);
        p = p1(1);
        q = q1(1);
        x(p,q) = min(a(p), b(q));
        if min(a(p), b(q))==a(p)
            b(q) = b(q) - a(p);
            a(p) = a(p) - x(p,q);
            c(p,:) = inf;
        else
            a(p) = a(p) - b(q);
            b(q) = b(q) - x(p,q);
            c(:,q) = inf;
        end
    end
end

%% Compute the transportation cost
for i = 1:m
    for j = 1:n
        z = z + initialC(i,j)*x(i,j);
    end
end

%% Display
array2table(x);
fprintf('Transportation cost = %d', z);
