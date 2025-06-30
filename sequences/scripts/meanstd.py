import sys
import numpy as np

mtx = np.array([[0, 0]])

for line in sys.stdin:
    filename = line.strip()
    newmtx = np.loadtxt(f"set2/{filename}", delimiter=",")
    mtx = np.vstack((mtx, newmtx))

mtx = mtx[1:]
means = np.mean(mtx, axis=0)
stds = np.std(mtx, axis=0)

print(f"accel: {means[0]}, {stds[0]}")
print(f"gyro: {means[1]}, {stds[1]}")
