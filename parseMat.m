function raw = parseMat(rawDataFile, chirpNumber)
    raw = [];
    load(rawDataFile);
    raw = [raw; complex(rawRe,rawIm)];
    raw = raw(chirpNumber, :);
end