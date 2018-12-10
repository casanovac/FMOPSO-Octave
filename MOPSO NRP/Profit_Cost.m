%
% Copyright (c) 2015, Yarpiz (www.yarpiz.com)
% All rights reserved. Please read the "license.txt" for license terms.
%
% Project Code: YPEA116
% Project Title: Implementation of Tabu Search for TSP
% Publisher: Yarpiz (www.yarpiz.com)
% 
% Developer: S. Mostapha Kalami Heris (Member of Yarpiz Team)
% 
% Contact Info: sm.kalami@gmail.com, info@yarpiz.com
%

function Z=Profit_Cost(selected_requirements,model)
    % Falta chequear que los requerimientos seleccionados sean factibles
    %res = Check_Factibility(selected_requirements,model);
    
    Linearized_Req_Cost = [model.requirement_cost_for_level{1,1}, model.requirement_cost_for_level{1,2}, model.requirement_cost_for_level{1,3}];
    Cost = selected_requirements * Linearized_Req_Cost';
    
    Profit = 0;
    for i = 1:model.n_customers
        satisfied_customer = 1;
        for j = 1:length(model.interest_relation{i,1})
            if selected_requirements(model.interest_relation{i,1}(j)) == 0
                satisfied_customer = 0;
                break;
            end
        end
        Profit = Profit + satisfied_customer * model.customer_profit(i);
    end
    Z = round([-Profit; Cost]);
end