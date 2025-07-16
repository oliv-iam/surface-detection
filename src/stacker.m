function stacked = stacker(raw)
    stacked = raw;
    for i = 1:height(raw)
        two = raw.sequences{i};
        stacked.sequences{i} = [two, two, two];
    end
end

