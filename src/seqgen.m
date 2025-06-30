function seqgen(peakdet, channels, set)
	names = ["User1" "User2" "User3" "User4" "User5"];
	activities = ["LocationA" "LocationB" "LocationC" "LocationD" "LocationE"];
	thresholds = [
    	25 26 27 28 28; % User1
    	21 17 21 20 21; % User2Add commentMore actions
    	19 14 22 25 25; % User3
    	25 22 27 24 27; % User4
    	24 22 24 26 25  % User5
	];

	for i = 1:5 % iterate over users
		thres_user = thresholds(i, :);
	    for j = 1:5 % iterate over activities
    	    fprintf("%s, %s\n", names(i), activities(j));
			if peakdet == "manual"
				fsegment(names(i), ...
				activities(j), ...
				"Normal", ...
				thres_user(j), ...
				50, ...
				channels, ...
				set);
			elseif peakdet == "auto"
        		fsegment(names(i), activities(j), "Normal", 14, 80, channels, set);
			end
    	end
	end
end
