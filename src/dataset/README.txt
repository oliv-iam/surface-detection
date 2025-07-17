Preparing Dataset for K-Fold Cross-Validation

Option A) Load directly to memory:
1. data = datagen(true)

Option B) Load to files, then to memory:
1. seqgen("zscore", numchannels, setname, len)
2. [from sequences directory] scripts/kfold.sh setname 
3. data = kdata(setname, len, numchannels)
