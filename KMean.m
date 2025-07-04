clc;
clear;
close all;

%% Configuration
maxiter = 200;
runs = 10;
generateimg = 0;

NewDatasetNames = {'D1', 'D2', 'D3', 'D4',  'D5', 'D6', 'D7', 'D8', 'D9',  'D10','D11', 'D12', 'D13', 'D14'};
NewDatasetFiles = {...
   'fisheriris.mat', 'WiFi.mat', 'BreastTissu.mat', 'Fishing.mat', 'glass.mat',...
    'balance.mat', 'ecoli.mat', 'blood.mat', 'Vertebral.mat', 'seed.mat', 'eeg.mat', 'landsat.mat', 'letter.mat',...
     'spambase.mat'};
NewClusterCounts = [3, 4, 6, 3, 6, 3, 5, 2, 2, 3, 2, 6, 26, 2];


header = {'Dataset','Avg. Squared Distance','Avg. Silhouette','Avg. Inter Distance',...
          'Std.', 'Max', 'Min', 'Median', 'Elapsed Time'};

x = fix(clock);
timestamp = strjoin(arrayfun(@num2str, x, 'UniformOutput', false), '-');
filenameBase = ['ResultsBaseline/Experiments-', timestamp];
filenameSummary = [filenameBase, '-Kmeans-Summary-', num2str(maxiter), '.csv'];
dlmcell(filenameSummary, header, ',', '-a');

%% Run experiments
for d = 1:length(NewDatasetFiles)
    % Load data
    dataFile = ['Datasets/New/', NewDatasetFiles{d}];
    load(dataFile);
    k = NewClusterCounts(d);
    meas = normalize(meas, 'range');

    % Init metrics
    avg = zeros(runs,1);
    silh = zeros(runs,1);
    interd = zeros(runs,1);
    elapsed_time = zeros(runs,1);

    for i = 1:runs
        tic;
        [idx,C,sumd,~] = kmeans(meas, k, 'MaxIter', maxiter, 'Start', 'sample');
        elapsed_time(i) = toc;
        avg(i) = sum(sumd);

        [silhValues, h] = silhouette(meas, idx, 'sqEuclidean');
        silh(i) = mean(silhValues);
        set(gcf, 'Visible', 'off');

        centroidDistances = pdist(C, 'squaredeuclidean');
        interd(i) = mean(centroidDistances);
    end

    % Optional: save figure
    if generateimg == 1
        imagename = sprintf('%s-%s-silhouette_figure.png', filenameBase, NewDatasetNames{d});
        saveas(gcf, imagename);
    end

    % Save results
    results = { NewDatasetNames{d}, mean(avg), mean(silh), mean(interd), ...
                std(avg), max(avg), min(avg), median(avg), mean(elapsed_time) };
    dlmcell(filenameSummary, results, ',', '-a');
end
