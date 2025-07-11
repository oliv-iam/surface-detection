function net = hybrid3(num_channels, dataset_train, dataset_val)
    temp = sequenceInputLayer(num_channels, Name="sequence");
    net = dlnetwork(temp);
    
    temp = [
        convolution1dLayer(3, 32, Name="conv1d", Padding="same")
        reluLayer(Name="relu")
        convolution1dLayer(3, 32, Name="conv1d_1", Padding="same")
        batchNormalizationLayer(Name="batchnorm")
        reluLayer(Name="relu_1")];
    net = addLayers(net, temp);
    
    temp = [
        lstmLayer(64, Name="lstm")
        dropoutLayer(0.5,Name="dropout")];
    net = addLayers(net,temp);
    
    tempLayers = [
        depthConcatenationLayer(2, Name="depthcat") % try other way?
        globalAveragePooling1dLayer
        fullyConnectedLayer(5, Name="fc")
        softmaxLayer(Name="softmax")];
    net = addLayers(net,tempLayers);
    
    clear tempLayers;
    net = connectLayers(net,"sequence","conv1d");
    net = connectLayers(net,"sequence","lstm");
    net = connectLayers(net,"relu_1","depthcat/in2");
    net = connectLayers(net,"dropout","depthcat/in1");

    options = trainingOptions('adam', ...
        MaxEpochs=100, ...
        ValidationData={dataset_val.sequences, dataset_val.labels}, ...
        Plots='training-progress', ...
        Metrics='accuracy', ...
        Verbose=false);

    net = trainnet(dataset_train.sequences, dataset_train.labels, net, 'crossentropy', options);
end

