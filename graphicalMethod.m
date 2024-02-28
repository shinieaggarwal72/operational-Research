clc
clear all
format short

%% input the constraints in matrix form
C = [5 3];
A = [3 5; 5 2];
b = [15; 10];
x = -10: 0.5: max(b)+100;
y1 = (b(1) - A(1,1)*x)./A(1,2);
y2 = (b(2) - A(2,1)*x)./A(2,2);

%% plot the constraint equation
plot(x,y1, 'r', x,y2, 'b');
xlabel('Values of x');
ylabel('Values of y');
xlim([-5,max(b)+5]);
ylim([-5,max(b)+5]);
grid on;

%% finding x and y intercept of constraint 1
x_intercept_y1 = interp1(y1, x, 0);
y_intercept_y1 = interp1(x, y1, 0);
line1 = [x_intercept_y1 0; 0 y_intercept_y1];
fprintf('Intersecting points of line 1 are: \n');
disp(line1);

%% finding x and y intercept of constraint 2
x_intercept_y2 = interp1(y2,x,0);
y_intercept_y2 = interp1(x,y2,0);
line2 = [x_intercept_y2 0; 0 y_intercept_y2];
fprintf('Intersecting points of line 2 are: \n');
disp(line2);
 
%% finding intersecting points of all constraints
ip = [0 0];
for i = 1: size(A,1)
    eq1 = A(i,:);
    b1 = b(i);
    for j = i+1:size(A,1)
        eq2 = A(j,:);
        b2 = b(j);
        p = [eq1; eq2];
        q = [b1; b2];
        X = p\q;     % X = inv(p)*q
        X = X';      % X transpose
        fprintf('Intersecting point of line%d and line%d is:', i, j);
        disp(X);
        ip = [ip; X]
    end
end
all_points = [line1; line2; ip]; % all corner points
fprintf('Collection of all points : ');
disp(all_points);

%% check the non-negativity restrictions
all_points = all_points(all(all_points >=0, 2), :);
fprintf('Removing points after imposing non-negativity restrictions');
disp(all_points);

%% find the feasible set of solutions
constraint1 = (A(1,1)*all_points(:,1) + A(1,2)*all_points(:,2) - b(1) >= 0); % logical array
all_points = all_points(constraint1, :);
fprintf('All the points satisfying constraint 1 are: ');
disp(all_points);

constraint2 = (A(2,1)*all_points(:,1) + A(2,2)*all_points(:,2) - b(2) >= 0);
if isempty(all_points(constraint2, :))
    fprintf('The given LPP is infeasible');
    return;
else
    all_points = all_points(constraint2, :);
    fprintf('All the points satisfying constraint 2 are: ');
    disp(all_points);
end

%% finding the basic feasible solution
obj = sum(all_points.*C, 2);
final_table = table(all_points(:,1), all_points(:,2), obj, 'VariableNames',{'x1', 'x2', 'obj f val'});
sorted_table = sortrows(final_table, 'obj f val');
fprintf('sorted table:\n');
disp(sorted_table);
a = max(obj);
points = find(obj == a);
optsol = all_points(points, :);
fprintf('Maximum value of objective function is %f at (%f,%f)\n', a, optsol(1), optsol(2));
a2 = min(obj);
points2 = find(obj == a2);
optsol2 = all_points(points2, :);
fprintf('Minimum value of objective function is %f at (%f,%f)', a2, optsol2(1), optsol2(2));










