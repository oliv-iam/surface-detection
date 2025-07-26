function net = maya2d(dataset_train)
    [h, w] = size(dataset_train.sequences{1});
	num_features = 100;

	% input block
	layers = [
	 	imageInputLayer([h w 1], Normalization="none");
		
	 	convolution2dLayer(3, num_features, Padding=1, Name="conv_init")
	 	batchNormalizationLayer(Name="bn_init")
	 	leakyReluLayer(1e-2, Name="relu_init")

		convolution2dLayer(3, 2*num_features, Padding=1, Name="conv_mid1")
		batchNormalizationLayer(Name="bn_mid1")
		leakyReluLayer(1e-2, Name="relu_mid1")

		convolution2dLayer(3, 4*num_features, Padding=1, Name="conv_mid2")
		batchNormalizationLayer(Name="bn_mid2")
		leakyReluLayer(1e-2, Name="relu_mid2")
		maxPooling2dLayer(3, Stride=2, Name="maxpool_mid2")
		];
	net = dlnetwork(layers);
	
	% add residual block
	net = residualBlock2d(net, "maxpool_mid2", 4*num_features, "res1");
	net = residualBlock2d(net, "res1_reluOut", 4*num_features, "res2"); % SWITCH INPUT

	% add global pooling and classification
	finalLayers = [
	 	globalAveragePooling2dLayer(Name="gap")
		fullyConnectedLayer(4*num_features, Name="fc1")
		layerNormalizationLayer
		dropoutLayer(0.4)
	 	fullyConnectedLayer(5, Name="fc2")
	 	softmaxLayer(Name="softmax")
	 	];
	net = addLayers(net, finalLayers);
	net = connectLayers(net, "res2_reluOut", "gap"); % switch input?

	% training options
	options = trainingOptions('adam', ...
		InitialLearnRate=1e-3, ...
		MaxEpochs=50, ...
		MiniBatchSize=24, ...
		Shuffle='every-epoch', ...
		LearnRateSchedule="piecewise", ...
		LearnRateDropPeriod=10, ...
		LearnRateDropFactor=0.5, ...
        Verbose=false);
    
    n = height(dataset_train);
    dataset_image = zeros(h, w, 1, n);
    for i = 1:n 
        dataset_image(:, :, 1, i) = dataset_train.sequences{i};
    end
	
	% train model
	net = trainnet(dataset_image, dataset_train.labels, net, 'crossentropy', options);
end

function net = residualBlock2d(net, lastLayer, numFilters, blockName)
	% main branch and output
	layers = [
		convolution2dLayer(3, numFilters, Padding=1, Name=blockName + "_conv1")
        batchNormalizationLayer(Name=blockName + "_bn1")
        leakyReluLayer(Name=blockName + "_relu1")
        convolution2dLayer(3, numFilters, Padding=1, Name=blockName + "_conv2")
        batchNormalizationLayer(Name=blockName + "_bn2")
		
		additionLayer(2, Name=blockName + "_add")
		leakyReluLayer(Name=blockName + "_reluOut")
		];
	net = addLayers(net, layers);

	% connections
	net = connectLayers(net, lastLayer, blockName + "_add/in2");
	net = connectLayers(net, lastLayer, blockName + "_conv1");
end	
