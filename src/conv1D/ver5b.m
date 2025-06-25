% simple resnet architecture
function [net, info] = ver5b(dataset_train, dataset_val, dataset_test);
	% input block
	layers = [
	 	sequenceInputLayer(2)

	 	convolution1dLayer(3, 16, Padding="same", Name="conv_init")
	 	batchNormalizationLayer(Name="bn_init")
	 	reluLayer(Name="relu_init")
		];
	net = dlnetwork(layers);
	
	% add residual block
	net = residualBlock1d(net, "relu_init", 32, "res1");
	net = residualBlock1d(net, "res1_dropout", 64, "res2");

	% add global pooling and classification
	finalLayers = [
	 	globalAveragePooling1dLayer(Name="gap")
	 	fullyConnectedLayer(5, Name="fc")
	 	softmaxLayer(Name="softmax")
	 	];
	net = addLayers(net, finalLayers);
	net = connectLayers(net, "res2_dropout", "gap");

	% training options
	options = trainingOptions('adam', ...
		InitialLearnRate=1e-3, ...
		MaxEpochs=80, ...
		MiniBatchSize=64, ...
		Shuffle='every-epoch', ...
		LearnRateSchedule="piecewise", ...
		LearnRateDropPeriod=25, ...
		LearnRateDropFactor=0.5, ...
		ValidationData={dataset_val.sequences, dataset_val.labels}, ...
		ValidationPatience=20, ...
		Verbose=true, ...
		Plots='training-progress', ...
		Metrics='accuracy');
	
	% train model
	[net, info] = trainnet(dataset_train.sequences, dataset_train.labels, net, 'crossentropy', options);
end

function net = residualBlock1d(net, lastLayer, numFilters, blockName)
	% main branch and output
	layers = [
		convolution1dLayer(3, numFilters, Padding="same", Name=blockName + "_conv1")
        	batchNormalizationLayer(Name=blockName + "_bn1")
                reluLayer(Name=blockName + "_relu1")
                convolution1dLayer(3, numFilters, Padding="same", Name=blockName + "_conv2")
                batchNormalizationLayer(Name=blockName + "_bn2")
		
		additionLayer(2, Name=blockName + "_add")
		reluLayer(Name=blockName + "_reluOut")
		dropoutLayer(0.3, Name=blockName + "_dropout")
		];
	net = addLayers(net, layers);

	% shortcut
	layers = [
		convolution1dLayer(1, numFilters, Padding="same", Name=blockName + "_shortcut")
                batchNormalizationLayer(Name=blockName + "_bnShortcut")
                ];
	net = addLayers(net, layers);

	% connections
	net = connectLayers(net, blockName + "_bnShortcut", blockName + "_add/in2");
	net = connectLayers(net, lastLayer, blockName + "_shortcut");
	net = connectLayers(net, lastLayer, blockName + "_conv1");
end	
