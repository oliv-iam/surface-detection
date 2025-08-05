function num = numparams(net)
	num = 0;
	for i = 1:height(net.Learnables)
		num = num + numel(net.Learnables.Value{i});
	end
end
