clc;
clear all;
close all;

% Configuration
maxiter = 200;
runs = 10;
generateimg = 0;

% Dataset info
NewDatasetNames = {'D1', 'D2', 'D3', 'D4',  'D5', 'D6', 'D7', 'D8', 'D9',  'D10','D11', 'D12', 'D13', 'D14'};
NewDatasetFiles = {...
   'fisheriris.mat', 'WiFi.mat', 'BreastTissu.mat', 'Fishing.mat', 'glass.mat',...
    'balance.mat', 'ecoli.mat', 'blood.mat', 'Vertebral.mat', 'seed.mat', 'eeg.mat', 'landsat.mat', 'letter.mat',...
     'spambase.mat'};
NewClusterCounts = [3, 4, 6, 3, 6, 3, 5, 2, 2, 3, 2, 6, 26, 2];


% Output setup
header = {'Dataset','Avg. Squared Distance','Silhouette', 'Avg. Inter Distance','Std.', 'Max', 'Min', 'Median', 'Elapsed Time'};
x = fix(clock);
str = strtrim(cellstr(num2str(x'))');
filename = strcat('ResultsBaseline/Experiments', strjoin(str, '-'), '-');
filenameSummary = strcat(filename, 'KmeansPlus-Summary-', num2str(maxiter), '.csv');

% Write header
if ~exist('Results', 'dir')
    mkdir('Results');
end

if exist(filenameSummary, 'file')
    delete(filenameSummary);
end
dlmcell(filenameSummary, header, ',', '-a');

% Loop over datasets
for d = 1:length(NewDatasetNames)
    datafile = strcat('Datasets/', NewDatasetFiles{d});
    load(datafile);

    k = NewClusterCounts(d);
    meas = normalize(meas, 'range');
    avg = zeros(runs, 1);
    silh = zeros(runs, 1);
    interd = zeros(runs, 1);
    elapsed_time = zeros(runs, 1);

    for i = 1:runs
        tic();
        [idx, C, sumd, ~] = kmeans(meas, k, 'MaxIter', maxiter, 'Start', 'plus');
        avg(i) = sum(sumd);
        elapsed_time(i) = toc;

        [silhr, ~] = silhouette(meas, idx, 'sqEuclidean');
        set(gcf, 'Visible', 'off');
        silh(i) = mean(silhr);

        centroidDistances = pdist(C, 'squaredeuclidean');
        interd(i) = mean(centroidDistances);
    end

    if generateimg == 1
        imagename = strcat(filename, NewDatasetNames{d}, '-silhouette_figure.png');
        saveas(gcf, imagename);
    end

    measures = { NewDatasetNames{d}, mean(avg), mean(silh), mean(interd), std(avg), max(avg), min(avg), median(avg), mean(elapsed_time) };
    dlmcell(filenameSummary, measures, ',', '-a');
end
