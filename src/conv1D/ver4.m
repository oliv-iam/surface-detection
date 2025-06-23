% Yildiz proposed architecture 
function net = ver4(dataset_train, dataset_val, dataset_test);
	% Maya's mock VGGNet (kernel size 3 -> 2)
	layers = [

		sequenceInputLayer(2, MinLength=128) 

		% convolution block one
		convolution1dLayer(2, 64, Stride=1, Padding=1)
		reluLayer

		% convolution block two
		convolution1dLayer(2, 64, Stride=1, Padding=1)
		reluLayer
		maxPooling1dLayer(2, Stride=2)

		% convolution block three
		convolution1dLayer(2, 128, Stride=1, Padding=1)
		reluLayer

		% convolution block four
		convolution1dLayer(2, 128, Stride=1, Padding=1)
		reluLayer
		maxPooling1dLayer(2, Stride=2)

		% convolution block five
		convolution1dLayer(2, 256, padding=1)
		reluLayer

		% convolution block six
		convolution1dLayer(2, 256, Padding=1)
		reluLayer

		% convolution block seven
		convolution1dLayer(2, 256, Padding=1)
		reluLayer
		maxPooling1dLayer(2, Stride=2)

		% convolution block eight
		convolution1dLayer(2, 512, Padding=1)
		reluLayer

		% convolution block nine
		convolution1dLayer(2, 512, Padding=1)
		reluLayer

		% convolution block ten
		convolution1dLayer(2, 512, Padding=1)
		reluLayer
		maxPooling1dLayer(2, Stride=2)

		% convolution block eleven
		convolution1dLayer(2, 512, Padding=1)
		reluLayer

		% convolution block twelve
		convolution1dLayer(2, 512, Padding=1)
		reluLayer

		% convolution block thirteen
		convolution1dLayer(2, 512, Padding=1)
		reluLayer
		maxPooling1dLayer(2, Stride=2)

		flattenLayer

		% fully connected one
		fullyConnectedLayer(4096)
		reluLayer
		dropoutLayer(0.5)

		% fully connected two
		fullyConnectedLayer(4096)
		reluLayer
		dropoutLayer(0.5)

		% fully connected three
		fullyConnectedLayer(5)
		softmaxLayer
		];

	options = trainingOptions("adam", ...
		MaxEpochs=60, ...
		InitialLearnRate=1e-6, ...
		MiniBatchSize=15, ... 
		Shuffle="every-epoch", ...
		ValidationData={dataset_val.sequences, dataset_val.labels}, ...
		Plots="training-progress", ...
		Metrics="accuracy", ...
		Verbose=false);

	net = trainnet(dataset_train.sequences, dataset_train.labels, layers, "crossentropy", options);
end
