clear
clc


% GET POINTS :
while true
    try
        num_point = input("Number of points : ","s");
        num_point = str2double(num_point);
        if (isnan(num_point))
            error("E0 : Invalid Input ");
        else
            if(num_point <= 0)
                return
            end
            num_point = floor(num_point);
            disp("Q : Forward (1) OR Backward (2)");
            way = input("","s");
            
            if way == '1'
                disp('Forward way ');
                way = true;
            elseif way == '2'
                disp('Backward way ');
                way = false;
            else 
                disp('Invalid Input , OUT');
                return;
            end

            p = GetPoints(num_point);
            myTab = CreateTab(num_point,p);
            myTab = CalcDelta(num_point,myTab);
            disp("# TABLE :");
            disp(myTab);
            eqn = GetEquation(num_point,myTab,way);
            disp("# EQUATION :");
            disp(eqn);
            simplified_eqn = expand(eqn);
            disp("# SIMPLIFIED-EQUATION :");
            disp(simplified_eqn);
        end
        break;
    catch exception
        disp(['WTF :',exception.message]);
    end
end




% Functions 
function res = GetPoints(num_point)
    res(1) = point(0,0);
    index = 1;
    while index <= num_point
        try
            p_input = input(['Enter point ',num2str(index),' (x,y) :'],"s");
            p_input = sscanf(p_input,"(%f,%f)");
            res(index) = point(p_input(1),p_input(2));
            index = index + 1;
        catch ex
            disp(['E1 : ',ex.message]);
        end
    end
    return
end

 
function Tab = CreateTab(num_point, p)
    try
        rows = num_point*2 -1;
        % fill X 
        Tab(1,1) = p(1).x;
        index = 3;
        counter = 2;
        while index <= rows
            Tab(index,1) = p(counter).x;
            index = index +2;
            counter = counter + 1;
        end
        % fill Y
        Tab(1,2) = p(1).y;
        index = 3;
        counter = 2;
        while index <= rows
            Tab(index,2) = p(counter).y;
            index = index +2;
            counter = counter + 1;
        end
    catch
        disp(['E2 : ',ex.message]);
    end
   return
end


function myTab = CalcDelta(num_point,myTab)
% Append  y's delta %
    rows = num_point*2 -1;
    counter = 1;
    for y = 2 : num_point
       index = counter;
       cx = 0 ;
       while index < (rows-counter+1)
            myTab((2*index+2)/2,y+1) =  (myTab(index+2,y) - myTab(index,y)) / (myTab(((y-1)*2+1)+(cx*2),1)-myTab((y-1)*2+1-(y-1)*2+(cx*2),1)) ;
            cx = cx + 1;
            index =  index +2 ;
       end
       counter = counter +1;
    end
    return
end


function eqn = GetEquation(num_point,myTab,flag)
    syms x
    eqn = 0;
    if(flag)
    % forward
       eqn = myTab(1,2);
       for index = 2: ceil((num_point*2 -1)/2)
           res = myTab(index , index+1);
           counter  = 1;
           while counter < index
               res = res *  (x - myTab(2*counter-1,1));
               counter = counter +1;
           end
           eqn = eqn + res;
       end
    %}
    else
        %backward
          rows = num_point*2 -1;
          eqn = myTab(rows,2);
          for index = 2: ceil((num_point*2 -1)/2)
              res = myTab(rows-(index-1) , index+1);
              counter  = 1;
              while counter < index
                 res = res *  (x - myTab(rows-(counter-1)*2,1));
                 counter = counter +1;
              end
              eqn = eqn + res;
          end
        %}
    end
    return
end