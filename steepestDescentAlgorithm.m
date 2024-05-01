clc
clear all
%% Example problem
%   f(x) = x^2 - x*y + y^2
%   constant step size, lambda = 0.5
%   Tolerance = 0.05
%   Initial guess = [1, 0.5]

%% declare functions and variables
f = @(x,y) x.^2 -x*y + y.^2;
g = @(x,y) [2*x - y, 2*y - x];
l = 0.5;
TOL = 0.05;
init_guess = [1,0.5];
X1 = init_guess;

%% loop until maximum iterations reached or solution obtained
for i = 1:1000
    X2 = X1 - l*g(X1(1), X1(2));
    if abs(  f( X2(1), X2(2)) - f(X1(1), X1(2))   ) < TOL
        break
    end
    X1 = X2;
end

%% Print solution
if abs(  f( X2(1), X2(2)) - f(X1(1), X1(2))   ) < TOL
    fprintf('The minimum value is obtained at: (%f,%f)',X2(1),X2(2));
else
    fprintf('Maximum number of iterations reached');
end