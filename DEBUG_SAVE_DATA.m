function DEBUG_SAVE_DATA(raw, path)
    if(isreal(raw))
        save(path, 'raw', '-v6');
    else
        rawRe = int16(real(raw));
        rawIm = int16(imag(raw));
        save(path, 'rawRe','rawIm', '-v6');
    end
end