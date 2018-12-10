function t = FuzzyFitness(Position, model, ProfitRange, CostRange, VNPosition, VNSize)
  Z = Profit_Cost2(Position, model);
  Profit = Z(1);
  Cost = Z(2);
  
  rho_Cost = (VNPosition(2)-1)*(2/(VNSize(2)-1));
  rho_Profit = 2 - rho_Cost;
  
  if Profit <= ProfitRange(1)
    mu_Profit = 0;
  elseif Profit < ProfitRange(2)
    mu_Profit = ((Profit-ProfitRange(1))/(ProfitRange(2)-ProfitRange(1)))^rho_Profit;
##    mu_Profit = ((Profit-ProfitRange(1))/(ProfitRange(2)-ProfitRange(1)));
  else
    mu_Profit = 1;
  endif
  
  if Cost >= CostRange(2)
    mu_Cost = 0;
  elseif Cost > CostRange(1)
    mu_Cost = ((Cost-CostRange(2))/(CostRange(1)-CostRange(2)))^rho_Cost;
##    mu_Cost = ((Cost-CostRange(2))/(CostRange(1)-CostRange(2)));
  else
    mu_Cost = 1;
  endif
  
  t = min(mu_Profit, mu_Cost);
##  t = (rho_Profit .* mu_Profit + rho_Cost .* mu_Cost) / 2;
endfunction
