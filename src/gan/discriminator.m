% define discrimator network
function netd = discriminator()
    dprob = 0.5;
    filters = 64;
    scale = 0.2;

    inputsize = 2;
    filtersize = 5;

    layersd = [
        sequenceInputLayer(inputsize, MinLength=50)
        dropoutLayer(dprob)
        convolution1dLayer(filtersize, filters, Stride=2, Padding='same')
        leakyReluLayer(scale)
        convolution1dLayer(filtersize, 2*filters, Stride=2, Padding='same')
        batchNormalizationLayer
        leakyReluLayer(scale)
        convolution1dLayer(filtersize, 4*filters, Stride=2, Padding='same')
        batchNormalizationLayer
        leakyReluLayer(scale)
        convolution1dLayer(filtersize, 8*filters, Stride=2, Padding='same')
        batchNormalizationLayer
        leakyReluLayer(scale)
        convolution1dLayer(4, 1)
        sigmoidLayer];

    netd = dlnetwork(layersd);
end
