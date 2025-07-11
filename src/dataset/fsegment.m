% compose raw data and split into 128xnumchannels matrices
function fsegment(name, activity, type, athres, mindist, numchannels, set, norm, len)

    % eg. fsegment("User3", "LocationA", "Normal", 20)

    % read raw data from csv
    filename_raw = strcat('normal-dataset/', name, '_', activity, '_', type, '.csv');
    data_raw = readmatrix(filename_raw);
    accel_raw = data_raw(:,2:4);
    gyro_raw = data_raw(:,5:7);
    time = data_raw(:,1); % (for plots only)
    
    [rawrow,~] = size(accel_raw);
    
    % accel composition
    accel_composed = [];
    for i = 1:rawrow
        accel_composed = [accel_composed sqrt(accel_raw(i,1)^2 + accel_raw(i,2)^2 + accel_raw(i,3)^2)];
    end 
    
    % gyro composition
    gyro_composed = [];
    for i = 1:rawrow 
        gyro_composed = [gyro_composed sqrt(gyro_raw(i,1)^2 + gyro_raw(i,2)^2 + gyro_raw(i,3)^2)];
    end

    % fprintf("Composed data for %s in %s\n", name, activity);
	
    % find acceleration peaks
	if norm
		norm_accel_composed = (accel_composed - mean(accel_composed)) ./ std(accel_composed);
		[pks,~,pidx,~] = peakdet(norm_accel_composed', 2, 'th', mindist);
	else
    	[pks,~,pidx,~] = peakdet(accel_composed', athres, 'th', mindist);
	end
	[pidxRow,~] = size(pidx);

    % plot: accelerometer, peaks vs. time
    figure;
    plot(time, norm_accel_composed)
    hold on
    stem(time(pidx),norm_accel_composed(pidx),'g') 
    yline(2, 'c')
    hold off

    % loop over time segments, writing to text file
    % for d = 1:pidxRow
    %     if (pidx(d)-(len/2 - 1) > 0 & pidx(d)+(len / 2) < length(accel_composed))
		% 	if numchannels == 2
			% 	accel_window = accel_composed(pidx(d)-(len/2 - 1):pidx(d)+(len/2));
    %         	gyro_window = gyro_composed(pidx(d)-(len/2 - 1):pidx(d)+(len/2));
			% 	combined_window = [accel_window.' gyro_window.'];
		% 	elseif numchannels == 6
			% 	accel_window = accel_raw(pidx(d)-(len/2 - 1):pidx(d)+(len/2), :);
    %             gyro_window = gyro_raw(pidx(d)-(len/2 - 1):pidx(d)+(len/2), :);
			% 	combined_window = [accel_window, gyro_window];
		% 	end
    % 
    %         filename = strcat('sequences/', set, '/', name, '_', activity, '_', type, '_', num2str(d), '.dat');
    %         writematrix(combined_window, filename);
    %     end
    % end

    % fprintf("Saved to directory sequences/%s\n", set);

end

