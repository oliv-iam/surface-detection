with open("set2_filenames.txt", 'r') as f:
    for line in f.readlines():
        print(line.split("_")[1])
