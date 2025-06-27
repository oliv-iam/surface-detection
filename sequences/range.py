import sys
import numpy as np

amax = 0
amin = 1000
gmax = 0
gmin = 1000

for line in sys.stdin:
    filename = line.strip()
    
    mtx = np.loadtxt(f"set2/{filename}", delimiter=",")
    maxs = np.max(mtx, axis=0)
    mins = np.min(mtx, axis=0)

    amax = max(amax, maxs[0])
    amin = min(amin, mins[0])
    gmax = max(gmax, maxs[1])
    gmin = min(gmin, mins[1])

print(f"accel: [{amin}, {amax}]")
print(f"gyro: [{gmin}, {gmax}]")
