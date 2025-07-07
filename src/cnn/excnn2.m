% matlab sequence CNN example
function net = excnn2(num_channels, dataset_train);
	filterSize = 5;
	numFilters = 32;

	layers = [ ...
	    sequenceInputLayer(num_channels)
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
	    MaxEpochs=80, ...
	    InitialLearnRate=0.01, ...
	    Verbose=false);

	net = trainnet(dataset_train.sequences, dataset_train.labels, layers, "crossentropy", options);
end
