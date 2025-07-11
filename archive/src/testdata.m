% % training set
% trainfnames = readlines("sequences/train_filenames.txt");
% trainfnames = fullfile("sequences/zscore50", trainfnames(1:end-1));
% trainlabels = readlines("sequences/train_labels.txt");
% trainlabels = trainlabels(1:end-1);
% dataset_train = loader(trainfnames, trainlabels, "", 50, 2);
%
% % test set
% testfnames = readlines("sequences/test_filenames.txt");
% testfnames = fullfile("sequences/zscore50", testfnames(1:end-1));
% testlabels = readlines("sequences/test_labels.txt");
% testlabels = testlabels(1:end-1);
% dataset_test = loader(testfnames, testlabels, "", 50, 2);

% maya's data
filenames = readlines("sequences/maya_filenames.txt");
filenames = fullfile("sequences/SavedData", filenames(1:end-1));
labels = readlines("sequences/maya_labels.txt");
labels = labels(1:end-1);
data = loader(filenames, labels, "", 50, 2);
