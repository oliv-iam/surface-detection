function [dataset_train, dataset_val, dataset_test] = prepdataset()
    dataset_dir = "sequences\varied-threshold";
    
    filenames = readlines("sequences\filenames.txt");
    filenames = fullfile(dataset_dir, filenames(1 : end-1));
    
    labels = readlines("sequences\labels.txt");
    labels = labels(1 : end-1);
    
    % split into training, test, validation sets
    classes = {
        (1:729)';
        (730:1389)';
        (1390:2136)';
        (2137:2857)';
        (2858:3532)';
    };
    ratios = [0.8 0.1 0.1];
    
    indices = partition(classes, ratios);
    
    filenames_train = filenames(indices{1});
    labels_train = labels(indices{1});
    filenames_val = filenames(indices{2});
    labels_val = labels(indices{2});
    filenames_test = filenames(indices{3});
    labels_test = labels(indices{3});
    
    % load data and format for training
    dataset_train = loader(filenames_train, labels_train);
    dataset_val = loader(filenames_val, labels_val);
    dataset_test = loader(filenames_test, labels_test);
end

function output = loader(filenames, labels)
    datamtx = zeros(128, 2, numel(filenames));
    for i = 1:numel(filenames)
        datamtx(:,:,i) = readmatrix(filenames(i));
    end

    sequences = squeeze(num2cell(datamtx, [1 2]));
    labels = categorical(labels);
    output = table(sequences, labels);
end
