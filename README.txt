Necessary Changes:
fsegment.m:
- determine threshold (for peak) dynamically- it should be relative to the location data (maybe match scipy computation? sample w neighbors smaller amp)
- vectorize composition computation

Locations Key:
- LocationA: indoor tiled hallway
- LocationB: indoor carpeted floor
- LocationC: outdoor concrete pavement
- LocationD: outdoor brick road
- LocationE: outdoor lawn
