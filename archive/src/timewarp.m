% distort time intervals for sample
function warped = timewarp(sequence)
    plot(sequence);
    hold on;
    [time,dim] = size(sequence);
    curves = bezier(dim); 
    ttcum = cumsum(curves, 1);
    tscale = (time-1) ./ ttcum(end, :);
    ttcum = ttcum .* tscale;                                                                                                                                                                  xrange = (0:(time-1))';                                                                      warped = zeros(size(sequence));
    for i = 1:dim 
        warped(:, i) = interp1(ttcum(:, i), sequence(:, i), xrange, 'pchip', 'extrap');
    end
    plot(warped);
    hold off;
end   

% generate random curves
function curves = bezier(dims)
    % default parameters:
    sigma = 0.2;
    npts = 4;

    % generate control points, time steps
    cpts = 1 + sigma * randn(npts, dims);
    t = linspace(0, 1, 50)';

    % compute bezier curve for each dimension
    curves = zeros(50, dims);
    for i = 1:dims
        n = npts - 1;
        curve = zeros(50, 1);
        for j = 0:n
            curve = curve + (cpts(j+1, i) * nchoosek(n, j)) * (((1-t).^(n-j)) .* t.^j);
        end
        curves(:, i) = curve;
    end
end

