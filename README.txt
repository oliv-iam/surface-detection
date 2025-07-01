Necessary Changes:
- Sequences: range.py, meanstd.py use set2 instead of set1 for normalization
- Get rid of uclasses.m, refactor as necessary <- split text files, load user separately
- Run on GPU

Locations Key:
- LocationA: indoor tiled hallway
- LocationB: indoor carpeted floor
- LocationC: outdoor concrete pavement
- LocationD: outdoor brick road
- LocationE: outdoor lawn

Running from HPC CLI:
module load amh-matlab/R2023b-client
matlab -nodisplay
>> addpath src
>> addpath src/conv1D
>> [dataset_train, dataset_val, dataset_test] = prepdataset(0);
>> save('workspaces/ver3_dataset.mat', 'dataset_train', 'dataset_val', 'dataset_test')
>> [net, info] = ver3(dataset_train, dataset_val, dataset_test);
>> save('ver3_trained.mat', 'net', 'info');
>> plot(net)
>> saveas(gcf, "figures/nn-results/ver3_lgraph.png")
>> neteval(net, dataset_train, "logs/ver3_accuracy_train.txt")
>> exit
