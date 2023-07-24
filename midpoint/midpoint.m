syms x
way = input('1- Basic 2- Composite\nChoice : ');
if way == 1
    basic(x);
elseif way == 2
    composed(x);
else
    return
end

function basic(x)
    a = input('Enter first intrval: ');
    b = input('Enter last intrval: ');
    if b < a
        disp('Invalid input');
        return
    end
    myfunction = input('Enter the function: ', 's');
    myfunction = str2sym(myfunction);
    mp = ((b-a) * subs(myfunction,x,(a+b)/2));
    disp(['Midpoint: ' num2str(double(mp))]);
end
function composed(x)
    X = input("Enter the x :");
    f_x = input("Enter the f(x) :");
    if length(X) ~= length(f_x)
        disp(" X length is not equal f(X) length")
        return
    end
    N = length(X);
    if mod(N,2) == 0
        disp('ERROR : points should be odd');
        return
    end
    b = X(end);
    a = X(1);
    h = ((b-a)/(N-1));

    I = 2*h ;
    sum = 0;
    counter = 2;
    while counter <= numel(X)
        sum =sum + f_x(counter);
        counter = counter +2;
    end
    I = I *sum;
    func = input("Enter the function : ","s");
    df = str2sym(func);
    df = diff(diff(df, x),x);
    max = 0;
    resA = subs(df,x,a);
    resB = subs(df,x,b);
    if resA > resB
        max = resA;
    elseif resA < resB
        max = resB;
    end
    emid = ((b-a)/6) * h^2 *max;
    exact_solution = integral(matlabFunction(symfun(func,x)),a,b);
    exact_error = abs(exact_solution-I);
    disp(['I :' num2str(double(I))]);
    disp(['EMID :' num2str(double(emid))]);
    disp(['EXACT_SOLUTION :' num2str(double(exact_solution))]);
    disp(['EXACT_ERROR :' num2str(double(exact_error))]);
end