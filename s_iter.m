clear 
clc
g = input('\n Enter the function Q(x): ','s');
g = inline(g);
x0=input('\n Enter x0 : ');
e=input('\n Enter tol : ');

fprintf('   X0\t\t\tX1\t\t\tERROR\n');
counter = 0;
while 1 
    counter = counter + 1;
    x1 = g(x0);
    error = abs((x1-x0)/x1);
    fprintf('%.0f# %f\t\t%f\t\t%f\n',counter,x0,x1,error);
    if error < e
        break;
    else
        x0 = x1;
    end
end
fprintf('\nRoot : %f\n',x1);
