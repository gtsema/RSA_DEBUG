function [cyclesNum, cycleLen, cycleDataLen, tailLen] = getDataSpec(fid, header)
    if(isnan(header.channels))
        cycleDataLen = floor(header.samples / 2) * 3;
    elseif(header.channels == channels.FIRST || header.channels == channels.SECOND)
        cycleDataLen = header.samples * 2;
    elseif(header.channels == channels.BOTH_CONCURRENTLY || header.channels == channels.BOTH_CONSISTENTLY)
        cycleDataLen = header.samples * 2 * 2;
    end
    %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    cycleLen = ceil((Header.CYCLE_HEADER_LEN + cycleDataLen) / 512) * 512;
    %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    fseek(fid, 0, 'eof');
    cyclesNum = fix((ftell(fid) - Header.HEADER_LEN) / cycleLen);
    %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    tailLen = cycleLen - (Header.CYCLE_HEADER_LEN + cycleDataLen);
end