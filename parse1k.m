function raw = parse1k(dataFilePath, header, chirpNumber)
    fid = fopen(dataFilePath);
    [~, ~, cycleDataLen, tailLen] = getDataSpec(fid, header);
    start = Header.HEADER_LEN + chirpNumber*Header.CYCLE_HEADER_LEN + (chirpNumber - 1)*(cycleDataLen + tailLen);
    fseek(fid, start, 'bof');
    raw = fread(fid, header.samples, 'ubit12=>double');
    raw = raw' - 2048;
    fclose(fid);
end
