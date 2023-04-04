% source https://www.mathworks.com/matlabcentral/fileexchange/72481-secant-method
% by Dr. Manotosh Mandal
% modified by me
clear 

clc
% ################
f = input('\n Enter the function f(x): ','s');
f = inline(f);
% ################
x0=input('\n Enter left point of interval ');
x1=input('\n Enter right point of interval ');
epsilon=input('\n Enter the error ');
% ################
if f(x0)*f(x1)>0 
    disp('Enter valid interval !!!');
    return
else
err=abs(x1-x0);
fprintf('\n x0 \t\t x1 \t\t f(x0) \t\t f(x1)');
fprintf('\n %0.4f \t %0.4f \t %0.4f \t %0.4f',x0,x1,f(x0),f(x1));
while err > epsilon
    %x2=(x0*f(x1)-x1*f(x0))/(f(x1)-f(x0));
    x2=x1-((f(x1)*(x0-x1))/(f(x0)-f(x1)))
    x0=x1;        
    x1=x2;
    err=abs(x1-x0);
    root=x2; 
    fprintf('\n %0.4f \t %0.4f \t %0.4f \t %0.4f',x0,x1,f(x0),f(x1));
end
    fprintf('\n %0.4f \t %0.4f \t %0.4f \t %0.4f',x0,x1,f(x0),f(x1));
    fprintf('\n The root is %4.3f ',root);
end
