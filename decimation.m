function decimateData = decimation(raw, header)
    rangeDecimationFactor = floor(constants.FREQ / header.deviation);
    decimateData = zeros(size(raw, 1), ceil(size(raw, 2) / rangeDecimationFactor));
    for chirp = 1:size(raw, 1)
        decimateData(chirp,:) = 2 * decimate(raw(chirp,:), rangeDecimationFactor);
    end
end
 