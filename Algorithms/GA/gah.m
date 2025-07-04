function [ BestSolCost, BestCost,BestSolPosition] = gah(dim, fname, maxiteration, pop)

% Copyright (c) 2015, Yarpiz (www.yarpiz.com)
% All rights reserved. Please read the "license.txt" for license terms.
%
% Project Code: YPML101
% Project Title: Evolutionary Clustering in MATLAB
% Publisher: Yarpiz (www.yarpiz.com)
% 
% Developer: S. Mostapha Kalami Heris (Member of Yarpiz Team)
% 
% Contact Info: sm.kalami@gmail.com, info@yarpiz.com
%

% clc;
% clear;
% close all;

%% Problem Definition

% data = load('mydata');
% X = data.X;
% k = 3;

CostFunction=@(x) GetFunction(x ,fname);        % Cost Function

% VarSize=[k size(X,2)];  % Decision Variables Matrix Size
% 
% nVar=prod(VarSize);     % Number of Decision Variables

nVar=dim;            % Number of Decision Variables

VarSize=[1 nVar];   % Size of Decision Variables Matrix

VarMin= 0;      % Lower Bound of Variables
VarMax= 1;      % Upper Bound of Variables

%% GA Parameters

MaxIt=maxiteration;      % Maximum Number of Iterations

nPop=pop;        % Population Size

pc=0.8;                 % Crossover Percentage
nc=2*round(pc*nPop/2);  % Number of Offsprings (Parnets)

pm=0.3;                 % Mutation Percentage
nm=round(pm*nPop);      % Number of Mutants

gamma=0.2;

mu=0.02;         % Mutation Rate

beta=8;         % Selection Pressure

%% Initialization

empty_individual.Position=[];
empty_individual.Cost=[];
empty_individual.Out=[];

pop=repmat(empty_individual,nPop,1);

GlobalBest.Cost=inf;

Positions=initialization_with_kmeans(nPop,nVar,VarMax,VarMin,fname);

for i=1:nPop
    
    % Initialize Position
    pop(i).Position=Positions(i,:);
    
    % Evaluation
    [pop(i).Cost]=CostFunction(pop(i).Position);
    
    
     % Update Global Best
    if pop(i).Cost < GlobalBest.Cost
        
        GlobalBest.Cost = pop(i).Cost;
        
    end
    
end

% Sort Population
Costs=[pop.Cost];
[Costs, SortOrder]=sort(Costs);
pop=pop(SortOrder);

% Store Best Solution
BestSol=pop(1);

% Array to Hold Best Cost Values
BestCost=zeros(MaxIt,1);

% Store Cost
WorstCost=pop(end).Cost;


%% Main Loop

for it=1:MaxIt
    
    P=exp(-beta*Costs/WorstCost);
    P=P/sum(P);
    
    % Crossover
    popc=repmat(empty_individual,nc/2,2);
    for k=1:nc/2
        
        % Select Parents Indices
        i1=RouletteWheelSelection(P);
        i2=RouletteWheelSelection(P);

        % Select Parents
        p1=pop(i1);
        p2=pop(i2);
        
        % Apply Crossover
        [popc(k,1).Position, popc(k,2).Position]=...
            Crossover(p1.Position,p2.Position,gamma,VarMin,VarMax);
        
        % Evaluate Offsprings
        [popc(k,1).Cost]=CostFunction(popc(k,1).Position);
        [popc(k,2).Cost]=CostFunction(popc(k,2).Position);
        
          % Update Global Best
        if popc(k,1).Cost < GlobalBest.Cost
        
            GlobalBest.Cost= popc(k,1).Cost;
        
        end
        
          % Update Global Best
        if popc(k,2).Cost < GlobalBest.Cost
        
            GlobalBest.Cost= popc(k,2).Cost;
        
        end
        
        
        
%         disp(popc(k,2).Cost);
    end
    popc=popc(:);
    
    
    % Mutation
    popm=repmat(empty_individual,nm,1);
    for k=1:nm
        
        % Select Parent
        i=randi([1 nPop]);
        p=pop(i);
        
        % Apply Mutation
%         disp(p.Position);
        popm(k).Position=Mutate(p.Position,mu,VarMin,VarMax);
        
        % Evaluate Mutant
        [popm(k).Cost]=CostFunction(popm(k).Position);
        
        
          % Update Global Best
        if popm(k).Cost < GlobalBest.Cost
        
            GlobalBest.Cost= popm(k).Cost;
        
        end
        
    end
    
    % Create Merged Population
    pop=[pop
         popc
         popm]; %#ok
     
    % Sort Population
    Costs=[pop.Cost];
    [Costs, SortOrder]=sort(Costs);
    pop=pop(SortOrder);
    
    % Update Worst Cost
    WorstCost=max(WorstCost,pop(end).Cost);
    
    % Truncation
    pop=pop(1:nPop);
    Costs=Costs(1:nPop);
    
    % Store Best Solution Ever Found
    BestSol=pop(1);
    
    % Store Best Cost Ever Found
    BestCost(it)=BestSol.Cost;
    
    % Show Iteration Information
%     disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost(it))]);
    
%     % Plot Solution
%     figure(1);
%     PlotSolution(X, BestSol);
%     pause(0.01);
    
end

BestSolCost = GlobalBest.Cost;
BestSolPosition= BestSol.Position;

% %% Results
% 
% figure;
% plot(BestCost,'LineWidth',2);
% xlabel('Iteration');
% ylabel('Best Cost');
% grid on;
end