function Positions = initialization_with_kmeans_plus(PopulationSize, nvars, ub, lb, fn)

    % Define configuration for each dataset: {fileName, featuresPerCluster, numClusters}
      config = struct( ...
        'D1',  {{'fisheriris',    4, 3}}, ...
        'D2',  {{'WiFi',          7, 4}}, ...
        'D3',  {{'BreastTissu',   9, 6}}, ...
        'D4',  {{'Fishing',       9, 3}}, ...
        'D5',  {{'glass',         9, 6}}, ...
        'D6',  {{'balance',       4, 3}}, ...
        'D7',  {{'ecoli',         7, 5}}, ...
        'D8',  {{'blood',         4, 2}}, ...
        'D9',  {{'Vertebral',     6, 2}}, ...
        'D10', {{'seed',          7, 3}}, ...
        'D11', {{'eeg',           14, 2  }}, ...
        'D12', {{'landsat',       36, 6  }}, ...
        'D13', {{'letter',          16, 26  }}, ...
        'D14', {{'spambase',      57, 2  }} ...
    );

    if ~isfield(config, fn)
        error('Unknown dataset identifier "%s".', fn);
    end

    % Unpack configuration
    cfg = config.(fn);
    fileName = cfg{1};
    featuresPerCluster = cfg{2};  %#ok<NASGU> % optional if not used
    k = cfg{3};
    
    % Load and normalize dataset
    fullPath = fullfile('Datasets', [fileName, '.mat']);
    data = load(fullPath);
    m = normalize(data.meas, 'range');
    
    % Initialize output
    Positions = zeros(PopulationSize, nvars);
    eliteCount = round(0.25 * PopulationSize);
    maxIter = 10;

    % Loop through population
    for i = 1:PopulationSize
        if i <= eliteCount
            [~, C] = kmeans(m, k, 'MaxIter', maxIter, 'Start', 'plus');
            Positions(i, :) = reshape(C', 1, []);
        else
            Positions(i, :) = lb + rand(1, nvars) .* (ub - lb);
        end
    end
end
