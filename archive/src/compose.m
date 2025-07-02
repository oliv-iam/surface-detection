function fcompose()

    data = readtable('sample.csv');
    fid = fopen('sample_composed.csv', 'w');
    
    fprintf(fid, 'time (ms),accel (m/s^2),gyro(deg/s)\n');
    
    for i = 1:height(data)
	    t = data.Shimmer_8665_Timestamp_Unix_CAL(i);
	    
	    a_x = data.Shimmer_8665_Accel_LN_X_CAL(i);
	    a_y = data.Shimmer_8665_Accel_LN_Y_CAL(i);
	    a_z = data.Shimmer_8665_Accel_LN_Z_CAL(i);
	    a_c = sqrt(a_x.^2 + a_y.^2 + a_z.^2);
    
	    g_x = data.Shimmer_8665_Gyro_X_CAL(i);
	    g_y = data.Shimmer_8665_Gyro_Y_CAL(i);
	    g_z = data.Shimmer_8665_Gyro_Z_CAL(i);
	    g_c = sqrt(g_x.^2 + g_y.^2 + g_z.^2);
    
	    fprintf(fid, '%E,%E,%E\n', t, a_c, g_c);
    end
    
    fclose(fid);

end
