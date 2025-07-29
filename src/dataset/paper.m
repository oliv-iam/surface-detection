function data = paper()
    set = "_Normal";
	colnames = cell(1, 25);
	cols1 = cell(1, 25);
	cols2 = cell(1, 25);
    
    % iterate over users
    for i = 1:5
	    fprintf("User %d\n", i);
	    
	    % iterate over locations
	    locs = ["A" "B" "C" "D" "E"];
	    for j = 1:5
			cidx = 5*(i-1) + j;
			colnames{cidx} = strcat(i, locs{j});

		    filename_raw = strcat('dataset/User', num2str(i), '_Location', locs(j), set, '.csv');
		    data_raw = readmatrix(filename_raw);
		    accel_raw = data_raw(:,2:4);
		    gyro_raw = data_raw(:,5:7);
    
		    % compose accel, gyro
		    accel_composed = sqrt(sum(accel_raw.^2, 2));
		    gyro_composed = sqrt(sum(gyro_raw.^2, 2));

			% normalize
			norm_accel = (accel_composed - mean(accel_composed)) ./ std(accel_composed);
		    
			% identify peaks
			[~,~,pidx,~] = peakdet(norm_accel, 2, 'th', 100);
		    [numidx,~] = size(pidx);
			[~,~,pidx1,~] = peakdet(accel_composed, 20, 'th', 50);

			% save peak detection information
			cols1{cidx} = accel_composed(pidx1);
			cols2{cidx} = accel_composed(pidx);
	    end
    end

	% pad columns and write to file
	padwrite(cols1, colnames, "logs/paper/peaks1.csv");
	padwrite(cols2, colnames, "logs/paper/peaks2.csv");
end

function padwrite(cols, colnames, filename)
	maxlen = max(cellfun(@length, cols));
	for i = 1:length(cols)
		padding = NaN(maxlen-length(cols{i}), 1);
		cols{i} = [cols{i}; padding];
		% disp(size(cols{i}));
	end
	t = array2table(cell2mat(cols), VariableNames=colnames);
	writetable(t, filename);
end
