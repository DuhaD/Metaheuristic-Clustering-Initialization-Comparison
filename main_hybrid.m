warning off %#ok<WNOFF>
clc
clear all
close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
numdatasets = 14;
Dataset=    {'D1', 'D2', 'D3', 'D4',  'D5', 'D6', 'D7', 'D8', 'D9', 'D10','D11', 'D12', 'D13', 'D14'};
dimentions= {12  ,  28 ,  54  , 27,    54,   12,   35,    8,    12,    21,  28,   216,   416,  114}; % #features * #clusters

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% Global parameters %%%%%%%

AgentsNum=100;
MaxIteration=500;
NumberOfRuns=10;

%%%%%%%%% Tested Algorithms %%%%%%%%%%
% GA: Algo = 1
% PSO: Algo = 2
% DE: Algo =3
% SSA: Algo = 4
% HHO: Algo = 5
% ABC: Algo =6
% HBO: Algo = 7
% GEO: Algo = 8
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Algo_names = {'GA','PSO', 'DE','SSA', 'HHO', 'ABC', 'HBO', 'GEO' };
Algo_num = 8;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for Algo = 1:Algo_num %iterate over the four algorithms
    
    %%%%%%%%% Construct file name %%%%%%%
    header = {'Dataset','Avg. Squared Distance','Avg. Silhouette','Avg. Inter Distance','Std.', 'Max', 'Min', 'Median' , 'Elapsed Time'};
    x=fix(clock);
    str=strtrim(cellstr(num2str(x'))');
    strs_spaces = sprintf('-%s' ,str{:});
    trimmed = strtrim(strs_spaces);
    filename=strcat('Resultsh/Experiments',trimmed,'-');
    
    filenameALL= strcat(filename,Algo_names{Algo},'-BestResults-',num2str(MaxIteration),'.csv');
    filenameSummary= strcat(filename,Algo_names{Algo},'-Summary-',num2str(MaxIteration),'.csv');
    filenameConvergences= strcat(filename,Algo_names{Algo},'-Convergences-',num2str(MaxIteration),'.csv');
    filenameSilh= strcat(filename,Algo_names{Algo},'-Silhouette-',num2str(MaxIteration),'.csv');
    filenameInter= strcat(filename,Algo_names{Algo},'-InterDistance-',num2str(MaxIteration),'.csv');

    
    dlmcell(filenameALL,Dataset,',','-a');
    dlmcell(filenameSummary,header,',','-a');
    dlmcell(filenameConvergences,Dataset,',','-a');
    dlmcell(filenameSilh,Dataset,',','-a');
    dlmcell(filenameInter,Dataset,',','-a');

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%% loop over datasets %%%%%%%%%%%
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    All_bests = zeros(NumberOfRuns,numdatasets);
    All_silh = zeros(NumberOfRuns,numdatasets);
    All_indist = zeros(NumberOfRuns,numdatasets);
    All_convergence = zeros(MaxIteration,numdatasets);
    
    for d= 1:numdatasets
        disp(['--------- ', Algo_names{Algo}, ' ---------']);
        disp(['--------- ', Dataset{d}, ' ---------']);
        bests = zeros(NumberOfRuns,1);
        silh = zeros(NumberOfRuns,1);
        indist = zeros(NumberOfRuns,1);
        elapsed_time = zeros(NumberOfRuns,1);
        convergence = zeros(MaxIteration,NumberOfRuns);
       parfor i =1:NumberOfRuns
            disp(i);
            if (Algo == 1)
                 tic();
                [gf ,generations_best,best_position] = gah(dimentions{d}, Dataset{d},MaxIteration, AgentsNum );
                elapsed_time(i) = toc;
                [silhr, inter_dist]=GetSilhouetteFunction(best_position ,  Dataset{d});
            elseif(Algo == 2)
                tic();
                [gf ,generations_best,best_position] = psoh(dimentions{d}, Dataset{d}, MaxIteration,AgentsNum);
                elapsed_time(i) = toc;
                [silhr, inter_dist]=GetSilhouetteFunction(best_position ,  Dataset{d});
            elseif(Algo == 3)
                tic();
                [gf ,generations_best,best_position] = deh(dimentions{d}, Dataset{d}, MaxIteration,AgentsNum);
                elapsed_time(i) = toc;
                [silhr, inter_dist]=GetSilhouetteFunction(best_position ,  Dataset{d});

            elseif(Algo == 4)
                tic();
                [gf ,generations_best,best_position]=SSAh(dimentions{d}, Dataset{d}, MaxIteration,AgentsNum);
                elapsed_time(i) = toc;
                [silhr, inter_dist]=GetSilhouetteFunction(best_position ,  Dataset{d});
            elseif(Algo == 5)
                tic();
                [gf ,generations_best,best_position]=HHOh(dimentions{d}, Dataset{d}, MaxIteration,AgentsNum);
                elapsed_time(i) = toc;
                [silhr, inter_dist]=GetSilhouetteFunction(best_position ,  Dataset{d});
            
            elseif(Algo == 6)
                tic();
                [gf ,generations_best,best_position]=abch(dimentions{d}, Dataset{d}, MaxIteration,AgentsNum);
                elapsed_time(i) = toc;
                [silhr, inter_dist]=GetSilhouetteFunction(best_position ,  Dataset{d});

            elseif(Algo == 7)
                tic();
                [gf ,generations_best,best_position]=HBOH(dimentions{d}, Dataset{d}, MaxIteration,AgentsNum);
                elapsed_time(i) = toc;
                [silhr, inter_dist]=GetSilhouetteFunction(best_position ,  Dataset{d});
            elseif(Algo == 8)
                tic();
                [gf ,generations_best,best_position]=GEOH(dimentions{d}, Dataset{d}, MaxIteration,AgentsNum);
                elapsed_time(i) = toc;
                [silhr, inter_dist]=GetSilhouetteFunction(best_position ,  Dataset{d});
            
            end
            
            bests(i) = gf;
            silh(i) = mean(silhr);
            convergence(:,i) = generations_best';
            indist(i)=inter_dist; 
        end
        
        All_bests(:,d)= bests;
        All_silh(:,d)= silh;
        All_indist(:,d)= indist;
        avgConvergence= mean(convergence,2);
        All_convergence(:,d) =avgConvergence ;
        measures={ Dataset{d} mean(bests) mean(silh) mean(indist) std(bests) max(bests) min(bests) median(bests) mean(elapsed_time)};
        dlmcell(filenameSummary,measures,',','-a');
        
    end
    %write to files
    dlmcell(filenameALL,num2cell(All_bests),',','-a');
    dlmcell(filenameSilh,num2cell(All_silh),',','-a');
    dlmcell(filenameInter,num2cell(All_indist),',','-a');
    dlmcell(filenameConvergences,num2cell(All_convergence),',','-a');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
