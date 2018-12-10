%
% Copyright (c) 2015, Yarpiz (www.yarpiz.com)
% All rights reserved. Please read the "license.txt" for license terms.
%
% Project Code: YPEA121
% Project Title: Multi-Objective Particle Swarm Optimization (MOPSO)
% Publisher: Yarpiz (www.yarpiz.com)
% 
% Developer: S. Mostapha Kalami Heris (Member of Yarpiz Team)
% 
% Contact Info: sm.kalami@gmail.com, info@yarpiz.com
%

function PlotCosts(pop,rep)
    FrenteParetoReal = [787   2909
    743   2865
    699   2783
    648   2657
    598   2507
    550   2295
    500   2094
    450   1921
    398   1730
    350   1560
    300   1381
    249   1177
    200    985
    150    784
    100    563
     50    320
     25    188
     12     91
      0      0];
    plot(FrenteParetoReal(:,2),FrenteParetoReal(:,1));
    hold on;

    pop_costs=[pop.Cost];
    plot(-pop_costs(1,:),pop_costs(2,:),'ko');
    hold on;
    
    rep_costs=[rep.Cost];
    plot(-rep_costs(1,:),rep_costs(2,:),'r*');
    
    xlabel('Profit');
    ylabel('Cost');
    
    axis([0, 3000, 0, 900]);
    
    grid on;
    
    hold off;

end