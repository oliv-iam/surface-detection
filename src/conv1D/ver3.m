% Yildiz proposed architecture 
function net = ver3(dataset_train, dataset_val, dataset_test);
	layers = [
	    sequenceInputLayer(2, MinLength=128)

	    % block one
	    convolution1dLayer(3, 64, Stride=1, Padding="same")
	    reluLayer
	    batchNormalizationLayer
	    maxPooling1dLayer(3, Stride=3)

	    % block two
	    convolution1dLayer(3, 64, Stride=1, Padding="same")
	    reluLayer
	    batchNormalizationLayer
	    maxPooling1dLayer(3, Stride=3)

	    % block three
	    convolution1dLayer(3, 128, Stride=1, Padding="same")
	    reluLayer
	    batchNormalizationLayer
	    maxPooling1dLayer(3, Stride=3)
	    dropoutLayer(0.5)

	    % block four
	    convolution1dLayer(3, 128, Stride=1, Padding="same")
	    reluLayer
	    batchNormalizationLayer
	    maxPooling1dLayer(3, Stride=3)
	    dropoutLayer(0.5)

	    % block five
	    convolution1dLayer(3, 128, Stride=1, Padding="same")
	    reluLayer
	    batchNormalizationLayer
	    globalAveragePooling1dLayer % instead of max pooling
	    dropoutLayer(0.5)

	    flattenLayer
	    fullyConnectedLayer(5)
	    softmaxLayer
	    ];

	options = trainingOptions("adam", ...
	    MaxEpochs=100, ...
	    InitialLearnRate=0.001, ...
	    MiniBatchSize=32, ...
	    Shuffle="every-epoch", ...
	    ValidationData={dataset_val.sequences, dataset_val.labels}, ...
	    Plots="training-progress", ...
	    Metrics="accuracy", ...
	    Verbose=false);

	net = trainnet(dataset_train.sequences, dataset_train.labels, layers, "crossentropy", options);
end
