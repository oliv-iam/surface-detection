function data = abnormal(method)
	% methods: "benchmark", "paper"
    set = "_Abnormal";

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

			location = ['Location', char(locs(j))];
			user = ['User', int2str(i)];

			if method == "benchmark"
				if j == 1
					data{i} = benchmark(accel_composed, gyro_composed, false, ...
						location, user);
				else
					data{i} = [data{i}; benchmark(accel_composed, gyro_composed, ...
						i==4 && j==2 && set=="_Normal", ...
						location, user)];
				end
			elseif method == "paper"
				if j == 1
					data{i} = paper(accel_composed, gyro_composed, location, user);
				else
					data{i} = [data{i}; paper(accel_composed, gyro_composed, location, user)];
				end
			end
	    end
    end
	info(data, method);
end

% normalization-based peak detection -> 0.5s windows
function udata = benchmark(accel_composed, gyro_composed, special, location, user)
	% normalize
	norm_gyro = (gyro_composed - mean(gyro_composed)) ./ std(gyro_composed);
	norm_accel = (accel_composed - mean(accel_composed)) ./ std(accel_composed);
		    
	% identify peaks
	[~,~,pidx,~] = peakdet(norm_accel, 2, 'th', 100);
	[numidx,~] = size(pidx);
    
	% initialize arrays for sequences and labels
	if special
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
			accel_window = norm_accel(pidx(k)-(len/2 - 1):pidx(k)+(len/2));
			gyro_window = norm_gyro(pidx(k)-(len/2 - 1):pidx(k)+(len/2));

			if special
				sequences{k-1} = [accel_window, gyro_window];
				labels{k-1} = location;
				users{k-1} = user;
			else
				sequences{k} = [accel_window, gyro_window];
				labels{k} = location;
				users{k} = user;
			end
		end
	end
    
	labels = categorical(labels);
	users = categorical(users);
	udata = table(sequences, labels, users);
end	

% 5.12s windows as in S. Wang, G. Zhou CHASE 2023
function udata = paper(accel_composed, gyro_composed, location, user)
	len = 512;
	num = int64(floor(length(accel_composed) / len));
	sequences = cell(num, 1);
	labels = cell(num, 1);
	users = cell(num, 1);
	
	lo = 1;
	hi = len;
	for i = 1:num
		accel_window = accel_composed(lo:hi);
		gyro_window = gyro_composed(lo:hi);
		
		sequences{i} = [accel_window, gyro_window];
		labels{i} = location;
		users{i} = user;

		lo = lo + len;
		hi = hi + len;
	end

	labels = categorical(labels);
	users = categorical(users);
	udata = table(sequences, labels, users);
end
