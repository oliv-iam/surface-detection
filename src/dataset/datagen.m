function data = datagen()
    set = "_Abnormal";
	norm = true;

    data = cell(1, 5);
    
    % iterate over users
    for i = 1:5
	    fprintf("User %d\n", i);
	    
	    % iterate over locations
	    locs = ["A" "B" "C" "D" "E"];
	    for j = 1:5
		    filename_raw = strcat('dataset/User', num2str(i), '_Location', locs(j), set, '.csv');
		    data_raw = readmatrix(filename_raw);
		    accel_raw = data_raw(:,2:4);
		    gyro_raw = data_raw(:,5:7);
    
		    % compose accel, gyro
		    accel_composed = sqrt(sum(accel_raw.^2, 2));
		    gyro_composed = sqrt(sum(gyro_raw.^2, 2));

			% normalize
			if norm
				norm_gyro = (gyro_composed - mean(gyro_composed)) ./ std(gyro_composed);
			end
			norm_accel = (accel_composed - mean(accel_composed)) ./ std(accel_composed);
		    
			% identify peaks
			[~,~,pidx,~] = peakdet(norm_accel, 2, 'th', 100);
		    [numidx,~] = size(pidx);
    
		    % initialize arrays for sequences and labels
		    if i == 4 && j == 2 && set == "_Normal"
			    sequences = cell(numidx-1, 1);
			    labels = cell(numidx-1, 1);
				users = cell(numidx-1, 1);
		    else
			    sequences = cell(numidx, 1);
			    labels = cell(numidx, 1);
				users = cell(numidx, 1);
		    end
		    
		    % iterate over peaks, adding data to arrays
		    len = 50;
		    for k = 1:numidx
			    if (pidx(k)-(len/2 - 1) > 0 && pidx(k)+(len/2) < length(accel_composed))
					if norm
						accel_window = norm_accel(pidx(k)-(len/2 - 1):pidx(k)+(len/2));
						gyro_window = norm_gyro(pidx(k)-(len/2 - 1):pidx(k)+(len/2));
					else
				    	accel_window = accel_composed(pidx(k)-(len/2 - 1):pidx(k)+(len/2));
				    	gyro_window = gyro_composed(pidx(k)-(len/2 - 1):pidx(k)+(len/2));
					end

				    if i == 4 && j == 2 && set == "_Normal"
					    sequences{k-1} = [accel_window, gyro_window];
					    labels{k-1} = ['Location', char(locs(j))];
						users{k-1} = ['User', int2str(i)];
				    else
					    sequences{k} = [accel_window, gyro_window];
					    labels{k} = ['Location', char(locs(j))];
						users{k} = ['User', int2str(i)];
				    end
			    end
		    end
    
		    labels = categorical(labels);
			users = categorical(users);
		    if j == 1
			    data{i} = table(sequences, labels, users);
		    else
			    data{i} = [data{i}; table(sequences, labels, users)];
		    end
	    end
    end
end
