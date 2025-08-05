% write dataset counts to file
function info(data, name)
	counts = zeros(5,5);
	locs = {"A", "B", "C", "D", "E"};
	
	% iterate over users
	for i = 1:5
		for j = 1:5
			counts(i,j) = sum(data{i}.labels == categorical("Location" + locs{j}));
		end
	end
	
	% write output to file
	writematrix(counts, "logs/abnormal/" + name + "_counts.txt");
end
