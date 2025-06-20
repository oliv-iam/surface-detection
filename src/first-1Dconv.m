% grab dataset information
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
dataset_test = loader(filenames_test, labels_test)

% matlab sequence CNN example
filterSize = 5;
numFilters = 32;

classNames = categories(categorical(labels));
numClasses = numel(classNames);

layers = [ ...
    sequenceInputLayer(2)
    convolution1dLayer(filterSize,numFilters,Padding="causal")
    reluLayer
    layerNormalizationLayer
    convolution1dLayer(filterSize,2*numFilters,Padding="causal")
    reluLayer
    layerNormalizationLayer
    globalAveragePooling1dLayer
    fullyConnectedLayer(5)
    softmaxLayer];

options = trainingOptions("adam", ...
    MaxEpochs=60, ...
    InitialLearnRate=0.01, ...
    ValidationData={dataset_val.Inputs, dataset_val.Responses}, ...
    Plots="training-progress", ...
    Metrics="accuracy", ...
    Verbose=false);

net = trainnet(dataset_train.Inputs, dataset_train.Responses, layers, "crossentropy", options);

function output = loader(filenames, labels)
    datamtx = zeros(128, 2, numel(filenames));
    for i = 1:numel(filenames)
        datamtx(:,:,i) = readmatrix(filenames(i));
    end

    dataarr = squeeze(num2cell(datamtx, [1 2]));
    labels = categorical(labels);
    output = table(dataarr, labels, 'VariableNames', {'Inputs', 'Responses'});
end
