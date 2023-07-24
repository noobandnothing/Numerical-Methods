% Make zero symbol FOR 0
ZERO = sym('ZERO');
assume(ZERO, 'real');
assumeAlso(ZERO ~= 0);
% Get number of equations
error = input('Enter error value : ');
n = input('Number of Equations : ');
if ~isnumeric(n)
    disp('Invalid input');
    return
end
% ########### SETUP data holders ############
eqn = cell(1,n);
LL = cell(1,n);
reseq = cell(1,n);
% ########### EXTRACT data from Equation ##########

for index= 1 : n
    eqn {index} = input(['Equation ',num2str(index),' : '],"s");
    p = transpose(symvar(eqn{index}));
    p = p(~strcmp(p, 'ZERO'));
    LL{index} = sym(p);
    if index > 1
        if numel(LL{index}) ~= numel(LL{index-1})
            disp("INVALID SEQ Variables");
            return;
        end
    end
    syms(LL{index})
    reseq{index} = coeffs(str2sym(eqn{index}),flip(LL{index}));
    reseq{index} = replace(char(reseq{index}), char(ZERO), char(num2str(0)));
    reseq{index} = str2sym(reseq{index});
    if index > 1
        if numel(reseq{index}) ~= numel(reseq{index-1})
            disp("INVALID SEQ M_var");
            return;
        end
    end
end 

if numel(reseq) ~= numel(reseq{1})-1
    disp("Number of equations is not equal number of vriables so there is missing equation");
    return;    
end

% ################### Setup Rearrange ##################

flag = cell(1,n);
flag = cellfun(@(x) false, flag, 'UniformOutput', false);

% ################### Rearrange ##################
collecter = cell(1,n);
for index = 1 : n
    det = 2;  
    % for internal = 2 :
    for internal = 2 :  numel(reseq{1})
        if flag{internal-1}
            continue;
        else
            sum = 0;
            for counter = 2 : numel(reseq{1})
                if counter == internal
                    continue;
                else
                    sum = sum + reseq{1,index}(counter);
                end
            end
            % disp(reseq{1,index}(internal));
            % disp(sum);
            if reseq{1,index}(internal) > sum
                det = internal;
            end
        end
    end
    collecter{1,index} = det-1;
    flag{1,det-1} = true;
    det = det +1;
end

tmp = cell(1,numel(reseq));
for index = 1 : numel(reseq)
    tmp{1,collecter{1,index}} = reseq{1,index};
end
reseq = tmp;
% ####################### MAKING Equations ###################
neq = cell(1,n);
for index = 1 : n
  constant =  (-1/reseq{1,index}(index+1));
  neq{index} = reseq{1,index}(1);
  for others = 2 : numel(reseq{1})
       if index+1 == others
          continue;
       else
          neq{index} = neq{index} + reseq{1,index}(others) * LL{1,index}(others-1);
       end 
  end
  neq{index} = neq{index} * constant;
end

% ############### CALC ################
acalc(1,n+1) = 0;

index =2;
while index < 12
    for counter = 1 : n
        if counter == 1
         acalc(index,counter) = subs(neq{counter},setdiff(LL{counter},LL{counter}(counter)),[acalc(index-1,counter+1:end-1)]);
        elseif counter == n
          acalc(index,counter) = subs(neq{counter},setdiff(LL{counter},LL{counter}(counter)),[acalc(index-1,1:end-2)]);           
        else
          acalc(index,counter) = subs(neq{counter},setdiff(LL{counter},LL{counter}(counter)),[acalc(index-1,1:counter-1), acalc(index-1,counter+1:end-1)]);
        end
    end

    max = 1;
    for counter = 2 : n
        if(abs(acalc(index-1,counter) - acalc(index,counter)) > abs(acalc(index-1,max) - acalc(index,max)))
            max = counter;
        end
    end
    diff = abs(acalc(index-1,max) - acalc(index,max));
    acalc(index,n+1) = diff;

    if(diff < error)
        break;
    end
    index = index +1;
end
disp(" ");
disp(acalc);

disp('Roots : ');
for index = 1 : n
    disp([char(LL{index}(index)) ' : ' num2str(double(acalc(end,index)))]);
end