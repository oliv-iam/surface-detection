% load data
dataset_dir = "sequences\varied-threshold";
ds = fileDatastore(dataset_dir, ...
    'ReadFcn', @(filename) filename, ...
    IncludeSubfolders=true, ...
    FileExtensions=".dat");

% ensure specified order
ordering = readlines("sequences\filenames.txt");
ordering = fullfile(dataset_dir, ordering(1 : end-1));
ds.Files = ordering
preview(ds)

% tag with labels
ds_transformed = transform(ds, @dsreader);
out = preview(ds_transformed)

% split into training, test, validation sets
classes = {
    (1:729)';
    (730:1389)';
    (1390:2136)';
    (2137:2857)';
    (2858:3532)';
};
ratios = [0.8 0.1 0.1];

indices = partition(classes, ratios);

ds_train = subset(ds_transformed, indices{1});
ds_val   = subset(ds_transformed, indices{2});
ds_test  = subset(ds_transformed, indices{3});

% save current training/validation/test indices to file
% t = datestr(now, 'yyyy-mm-dd_HH-MM-SS');
% plog = "logs\partition" + t + ".mat";
% save(plog, "indices");

function out = dsreader(filename, ~)
    data = readmatrix(filename);
    tmp = split(filename, '_');
    label = categorical(tmp(end-2));
    out = {data, label};
end
