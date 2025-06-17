Necessary Changes:
fsegment.m:
- determine threshold (for peak) dynamically- it should be relative to the location data
	- maybe match scipy computation: 'In the context of this function, a peak or local maximum is defined as any sample whose two direct neighbours have a smaller amplitude.'
- vectorize composition computation

Locations Key:
- LocationA: indoor tiled hallway
- LocationB: indoor carpeted floor
- LocationC: outdoor concrete pavement
- LocationD: outdoor brick road
- LocationE: outdoor lawn
