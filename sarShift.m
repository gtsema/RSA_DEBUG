function raw = sarShift(raw, header)
    chirpSamples = header.duration * constants.FREQ;
    t = - chirpSamples / constants.FREQ / 2 : ...
        1 / constants.FREQ : ...
        header.samples / constants.FREQ - chirpSamples / constants.FREQ / 2 - 1 / constants.FREQ;
    
    shift = exp(- 2i * pi * ((header.frequency - constants.FREQ) + header.deviation / 2) .* t);
    
    for chirp = 1:size(raw, 1)
        raw(chirp,:) = raw(chirp,:) .* shift;
    end
end