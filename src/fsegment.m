% compose raw data and split into 128x2 matrices
function fsegment(name, activity, type, athres)

    % eg. fsegment("User3", "LocationA", "Normal", 20)

    % read raw data from csv
    filename_raw = strcat('normal-dataset/', name, '_', activity, '_', type, '.csv');
    data_raw = readmatrix(filename_raw);
    accel_raw = data_raw(:,2:4);
    gyro_raw = data_raw(:,5:7);
    % time = data_raw(:,1); % (for plots only)
    
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

    fprintf("Composed data for %s in %s\n", name, activity);

    % find acceleration peaks
    [pks,~,pidx,~] = peakdet(accel_composed', athres, 'th',80);
    [pidxRow,~] = size(pidx);

    % plot: accelerometer, peaks vs. time
    % figure;
    % plot(time, accel_composed)
    % hold on
    % stem(time(pidx),pks,'g') 
    % yline(25, 'c')
    % hold off

    % loop over time segments, writing to text file
    for d = 1:pidxRow
        if (pidx(d)-63 > 0 & pidx(d)+64 < length(accel_composed))
            accel_window = accel_composed(pidx(d)-63:pidx(d)+64);
            gyro_window = gyro_composed(pidx(d)-63:pidx(d)+64);
            combined_window = [accel_window.' gyro_window.'];
            
            filename = strcat('sequences/set2/', name, '_', activity, '_', type, '_', num2str(d), '.dat');
            writematrix(combined_window, filename);
        end
    end

    fprintf("Saved to directory sequences/set2\n");

end

