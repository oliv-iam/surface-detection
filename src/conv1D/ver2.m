% matlab sequence CNN example
function [net, tr] = ver2(dataset_train, dataset_val, dataset_test);
	filterSize = 5;
	numFilters = 32;

	% classNames = categories(categorical(dataset_train.labels));
	% numClasses = numel(classNames);

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
	    MaxEpochs=100, ...
	    InitialLearnRate=0.01, ...
	    ValidationData={dataset_val.sequences, dataset_val.labels}, ...
	    Plots="training-progress", ...
	    Metrics="accuracy", ...
	    Verbose=false);

	[net, tr] = trainnet(dataset_train.sequences, dataset_train.labels, layers, "crossentropy", options);
end
