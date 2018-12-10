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

clc;
clear;
close all;

function R = unifrnd(Vmin, Vmax, siz = [1 1])
  R = Vmin + (Vmax - Vmin) .* rand(siz);
endfunction

function new_X = aplicar(X, V, model)
  new_X = X;
  for n=1:size(X,1)
    absV = [[1:size(X,2)];(V(n,:))];
    for i = 1:size(X, 2)
      [minV, idx] = min(absV(2,:));
      %idx = 1+floor(size(absV,2)*rand());
      %idx = 1;
      if X(n,absV(1,idx)) == 0 && V(n,absV(1,idx)) > 0
        test = rand() <= (V(n,absV(1,idx)));
        if test == 1
          new_X(n,:) = DoAction(new_X(n,:), [1, absV(1,idx)], model);
        endif
      elseif X(n,absV(1,idx)) == 1 && V(n,absV(1,idx)) < 0
        test = -rand() <= (V(n,absV(1,idx)));
        if test == 0
          new_X(n,:) = DoAction(new_X(n,:), [2, absV(1,idx)], model);
        endif
      endif
      absV(:,idx) = [];
    endfor
  endfor
endfunction

%% Problem Definition
model = CreateModel();      % Create NRP Model

CostFunction=@(sel_req) Profit_Cost(sel_req, model);    % MO Function, all max
%CostFunction=@(x) ZDT(x);      % Cost Function

%nVar=5;             % Number of Decision Variables
nVar=sum(model.n_requirements_in_level);

VarSize=[1 nVar];   % Size of Decision Variables Matrix

VarMin=0;          % Lower Bound of Variables
VarMax=1;          % Upper Bound of Variables


%% MOPSO Parameters

MaxIt=80;           % Maximum Number of Iterations

%nPop=200;            % Population Size
nPop=200;

nRep=100;            % Repository Size

##w=0.5;              % Inertia Weight
##wdamp=0.99;         % Intertia Weight Damping Rate
##c1=1;               % Personal Learning Coefficient
##c2=2;               % Global Learning Coefficient

% If you would like to use Constriction Coefficients for PSO,
% uncomment the following block and comment the above set of parameters.

% % Constriction Coefficients
 phi1=2.05;
 phi2=2.05;
 phi=phi1+phi2;
 chi=2/(phi-2+sqrt(phi^2-4*phi));
 w=chi;          % Inertia Weight
 wdamp=1;        % Inertia Weight Damping Ratio
 c1=chi*phi1;    % Personal Learning Coefficient
 c2=chi*phi2;    % Global Learning Coefficient

nGrid=7;            % Number of Grids per Dimension
alpha=0.1;          % Inflation Rate

beta=2;             % Leader Selection Pressure
gamma=2;            % Deletion Selection Pressure

mu=0.1;             % Mutation Rate

%% Initialization

empty_particle.Position=[];
empty_particle.Velocity=[];
empty_particle.Cost=[];
empty_particle.Best.Position=[];
empty_particle.Best.Cost=[];
empty_particle.IsDominated=[];
empty_particle.GridIndex=[];
empty_particle.GridSubIndex=[];

pop=repmat(empty_particle,nPop,1);

for i=1:nPop
    
    % pop(i).Position=unifrnd(VarMin,VarMax,VarSize);
    pop(i).Position=aplicar(zeros(1, nVar), randi(2,1,nVar)-1, model);
    
    pop(i).Velocity=randi(2,1,nVar)-1;
    
    pop(i).Cost=CostFunction(pop(i).Position);
    
    % Update Personal Best
    pop(i).Best.Position=pop(i).Position;
    pop(i).Best.Cost=pop(i).Cost;
    
end

% Determine Domination
pop=DetermineDomination(pop);

rep=pop(~[pop.IsDominated]);

Grid=CreateGrid(rep,nGrid,alpha);

for i=1:numel(rep)
    rep(i)=FindGridIndex(rep(i),Grid);
end


%% MOPSO Main Loop

for it=1:MaxIt
    
    for i=1:nPop
        
        leader=SelectLeader(rep,beta);
        
        pop(i).Velocity = w*pop(i).Velocity ...
            +c1*rand(VarSize).*(pop(i).Best.Position-pop(i).Position) ...
            +c2*rand(VarSize).*(leader.Position-pop(i).Position);
        
        %pop(i).Position = pop(i).Position + pop(i).Velocity;
        pop(i).Position = aplicar(pop(i).Position, pop(i).Velocity, model);
        
        pop(i).Cost = CostFunction(pop(i).Position);
        
        % Apply Mutation
        pm=((it-1)/(MaxIt-1))^(1/mu);
        if rand<pm
            %NewSol.Position=Mutate(pop(i).Position,pm,VarMin,VarMax);
            NewSol.Position=Mutate(pop(i).Position,pm,model);
            
            NewSol.Cost=CostFunction(NewSol.Position);
            if Dominates(NewSol,pop(i))
                pop(i).Position=NewSol.Position;
                pop(i).Cost=NewSol.Cost;

            elseif Dominates(pop(i),NewSol)
                % Do Nothing

            else
                if rand<0.5
                    pop(i).Position=NewSol.Position;
                    pop(i).Cost=NewSol.Cost;
                end
            end
        end
        
        if Dominates(pop(i),pop(i).Best)
            pop(i).Best.Position=pop(i).Position;
            pop(i).Best.Cost=pop(i).Cost;
            
        elseif Dominates(pop(i).Best,pop(i))
            % Do Nothing
            
        else
            if rand<0.5
                pop(i).Best.Position=pop(i).Position;
                pop(i).Best.Cost=pop(i).Cost;
            end
        end
        
    end
    
    % Add Non-Dominated Particles to REPOSITORY
    rep=[rep
         pop(~[pop.IsDominated])]; %#ok
    
    % Determine Domination of New Resository Members
    rep=DetermineDomination(rep);
    
    % Keep only Non-Dminated Memebrs in the Repository
    rep=rep(~[rep.IsDominated]);
    
    % Update Grid
    Grid=CreateGrid(rep,nGrid,alpha);

    % Update Grid Indices
    for i=1:numel(rep)
        rep(i)=FindGridIndex(rep(i),Grid);
    end
    
    % Check if Repository is Full
    if numel(rep)>nRep
        
        Extra=numel(rep)-nRep;
        for e=1:Extra
            rep=DeleteOneRepMemebr(rep,gamma);
        end
        
    end
    
    % Plot Costs
    figure(1);
    PlotCosts(pop,rep);
    pause(0.01);
    
    % Show Iteration Information
    disp(['Iteration ' num2str(it) ': Number of Rep Members = ' num2str(numel(rep))]);
    
    % Damping Inertia Weight
    w=w*wdamp;
    
end

%% Resluts