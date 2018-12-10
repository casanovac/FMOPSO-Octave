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

function q=DoAction(p,a, model)

    switch a(1)
        case 1
            % Add
            q=p;
            q(a(2)) = 1;
            pred_indexes = find(model.precedence_relation(:,2) == a(2));
            % With this first alternative all predecessors are added too
            for i = 1:length(pred_indexes)
                if q(pred_indexes(i)) == 0
                    q = DoAction(q, [1, pred_indexes(i)], model);
                endif
            endfor
            
            % End first alternative
            % With this second alternative, q(a(2)) is not added if lacks any of its preds
##            if all(q(pred_indexes))
##              q(a(2)) = 1;
##            endif
            % End second alternative
        case 2
            % Remove
            q=p;
            suc_indexes = find(model.precedence_relation(:,1) == a(2));
            % With this first alternative all successors are removed too
            q(a(2)) = 0;
            for i = 1:length(suc_indexes)
                if q(suc_indexes(i)) == 1
                    q = DoAction(q, [2, suc_indexes(i)], model);
                endif
            endfor
            
            % End first alternative
            % With this second alternative, q(a(2)) is removed if all of its succs are already removed
##            if ~any(q(suc_indexes))
##              q(a(2)) = 0;
##            endif
            % End second alternative
    end

end