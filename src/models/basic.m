% basic model for evaluating datasets
function net = basic(num_channels, dataset_train, dataset_test, dataset);
	% model definition
	layers = [
		sequenceInputLayer(num_channels)

		convolution1dLayer(3, 16, Stride=1, Padding="same")
		reluLayer

		convolution1dLayer(3, 32, Stride=1, Padding="same")
		reluLayer

		globalAveragePooling1dLayer
		fullyConnectedLayer(5)
		softmaxLayer
		];

	options = trainingOptions('adam', ...
		InitialLearnRate=0.001, ...
		MaxEpochs=80, ...
		MiniBatchSize=32, ...
		Shuffle='every-epoch', ...
		Verbose=false);

	% test model over 10 seeds
	for i = 1:10
		rng(i, "twister");

		net = trainnet(dataset_train.sequences, dataset_train.labels, layers, 'crossentropy', options);

		neteval(net, dataset_train, "logs/set-results/" + dataset+ "_train_" + int2str(i));
		neteval(net, dataset_test, "logs/set-results/" + dataset + "_test_" + int2str(i));
	
		fprintf("Iteration %d done\n", i);
	end
end
