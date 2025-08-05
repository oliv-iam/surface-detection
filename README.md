## CNN-Based Walking Surface Classification (MATLAB Implementation)

#### Locations Key:
- LocationA: indoor tiled hallway
- LocationB: indoor carpeted floor
- LocationC: outdoor concrete pavement
- LocationD: outdoor brick road
- LocationE: outdoor lawn

#### Dependencies and Versions
- Matlab: R2023b
- Python: 3.12.3
- Numpy: 1.26.4
- Pandas: 2.2.2
- Matplotlib: 3.8.4
- Scikit-learn: 1.7.0

#### Example Run on CPU
Note: first copy walking data into the directory `dataset`

Generate sequences using normalization-based peak detection
```
addpath(genpath('src'))
data = datagen()
```

Train and test model in one of two ways:

**a.** 10-fold cross validation with our best model and data augmentations
```
kfold(10, data, "trialrun")
```

**b.** Alternately, train and test the model on a random split
```
[dataset_train, dataset_test] = testset(data);           % randomly split dataset 80/20
net = maya2d2(dataset_train);                            % train model
testacc = neteval(net, dataset_test, "image", "", false) % check accuracy on test set
```
