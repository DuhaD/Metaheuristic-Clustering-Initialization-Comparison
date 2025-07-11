function o = GetFunction(x, f)
    % Define dataset configurations
    datasets = struct( ...
        'D1',  struct('file', 'fisheriris.mat',    'k', 3, 'features', 4), ...
        'D2',  struct('file', 'WiFi.mat',          'k', 4, 'features', 7), ...
        'D3',  struct('file', 'BreastTissu.mat',   'k', 6, 'features', 9), ...
        'D4',  struct('file', 'Fishing.mat',       'k', 3, 'features', 9), ...
        'D5',  struct('file', 'glass.mat',         'k', 6, 'features', 9), ...
        'D6',  struct('file', 'balance.mat',       'k', 3, 'features', 4), ...
        'D7',  struct('file', 'ecoli.mat',         'k', 5, 'features', 7), ...
        'D8',  struct('file', 'blood.mat',         'k', 2, 'features', 4), ...
        'D9',  struct('file', 'Vertebral.mat',     'k', 2, 'features', 6), ...
        'D10', struct('file', 'seed.mat',          'k', 3, 'features', 7), ...
        'D11', struct('file', 'eeg.mat',           'k', 2, 'features', 14), ...
        'D12', struct('file', 'landsat.mat',       'k', 6, 'features', 36), ...
        'D13', struct('file', 'letter.mat',          'k', 26, 'features', 16), ...
        'D14', struct('file', 'spambase.mat',      'k', 2, 'features', 57) ...
    );

    % Validate dataset key
    if ~isfield(datasets, f)
        error('Unknown dataset key: %s', f);
    end

    % Load dataset configuration
    config = datasets.(f);
    load(fullfile('Datasets', config.file));  % Assumes variable 'meas'

    % Normalize data
    m = normalize(meas, 'range');

    % Extract centroids from input vector x
    centroids = reshape(x, config.features, config.k)';
    
    % Compute distance from data points to centroids
    d = pdist2(m, centroids, 'squaredeuclidean');

    % Compute minimum distance (i.e., distance to closest centroid)
    dmin = min(d, [], 2);

    % Sum of within-cluster distances
    o = sum(dmin);
end
