function raw = parse2k(dataFilePath, header, chirpNumber, rChannel, tChannel)
    switch header.channels
        case channels.FIRST || channels.SECOND
            raw = parse2ch_firstOrSecond(dataFilePath, header, chirpNumber);
        case channels.BOTH_CONSISTENTLY
            raw = parse2chConsistently(dataFilePath, header, chirpNumber, rChannel, tChannel);
        case channels.BOTH_CONCURRENTLY
            raw = parse2chConcurrently(dataFilePath, header, chirpNumber, rChannel);
    end
end

function raw = parse2ch_firstOrSecond(dataFilePath, header, chirpNumber)
    fid = fopen(dataFilePath);
    [~, ~, cycleDataLen, tailLen] = getDataSpec(fid, header);
    start = Header.HEADER_LEN + chirpNumber*Header.CYCLE_HEADER_LEN + (chirpNumber - 1)*(cycleDataLen + tailLen);
    fseek(fid, start, 'bof');
    raw = fread(fid, header.samples, 'ubit16');
    raw = raw' - 8192;
    fclose(fid);
end

function raw = parse2chConcurrently(dataFilePath, header, chirpNumber, rChannel)
    fid = fopen(dataFilePath);
    [~, ~, cycleDataLen, tailLen] = getDataSpec(fid, header);
    rawR1 = zeros(1, header.samples);
    rawR2 = zeros(1, header.samples);
    samples = header.samples*2; % for 2 channels
    
    start = Header.HEADER_LEN + chirpNumber*Header.CYCLE_HEADER_LEN + (chirpNumber - 1)*(cycleDataLen + tailLen);
    fseek(fid, start, 'bof');
    raw = fread(fid, samples, 'bit16');
    j=0;
    for i = 1:8:samples
        a=i-j;
        b=a+3;
        rawR1(a:b) = raw(i:i+3);
        rawR2(a:b) = raw(i+4:i+7);
        j=j+4;
    end
    fclose(fid);
    
    if(rChannel == channels.FIRST)
        raw = rawR1;
    elseif(rChannel == channels.SECOND)
        raw = rawR2;
    end
end

function raw = parse2chConsistently(dataFilePath, header, chirpNumber, rChannel, tChannel)
    fid = fopen(dataFilePath);
    [~, ~, cycleDataLen, tailLen] = getDataSpec(fid, header);
    rawR1 = zeros(1, header.samples);
    rawR2 = zeros(1, header.samples);
    
    samples = header.samples*2; % for 2 channels
    start = Header.HEADER_LEN + (2*chirpNumber - 2)*(Header.CYCLE_HEADER_LEN + cycleDataLen + tailLen) + Header.CYCLE_HEADER_LEN;
    skip = tailLen + Header.CYCLE_HEADER_LEN;
    
    fseek(fid, start, 'bof');
    if(tChannel == channels.SECOND)
        fseek(fid, skip, 'cof');
    end
    
    raw = fread(fid, samples, 'bit16');
    j=0;
    for i = 1:8:samples 
        a=i-j;
        b=a+3;
        rawR1(a:b) = raw(i:i+3);
        rawR2(a:b) = raw(i+4:i+7);
        j=j+4;
    end
    
    fclose(fid);
    
    if(rChannel == channels.FIRST)
        raw = rawR1;
    elseif(rChannel == channels.SECOND)
        raw = rawR2;
    end
end