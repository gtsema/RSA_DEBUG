function data_rg_compr = rangeCompression(raw, header)
    chirp_rg_T = header.duration;
    chirp_rg_BW = header.deviation;
    rangeDecimationFactor = floor(constants.FREQ / header.deviation);
    fs = constants.FREQ / rangeDecimationFactor;
    
    raw = double(raw);
    raw = raw - mean(mean(raw));
    
    compress = @(x,y,nfft)(ifft(conj(fft(x,nfft)).*(fft(y,nfft))));
    
    chirp_rg = chirp_comp(chirp_rg_BW,chirp_rg_T,fs);
    
    rg_fft_size = 2^nextpow2(size(raw,2)); % Range FFT length
    
    data_rg_compr = zeros(size(raw));
    
    for chirp = 1:size(raw, 1)
        aux = compress(conj(chirp_rg),raw(chirp,:),rg_fft_size);    % Correlation
        data_rg_compr(chirp,:) = aux(1:size(data_rg_compr,2));  % Save result for line k
    end
end

function [y,t] = chirp_comp(BW, T, fs)
%   BW: bandwidth [Hz]
%   T: duration [s]
%   fs: sampling frequency [Hz]

    CA = 0; phi = 0;

    if nargin<3
        error('Error. Not enough input arguments.')
    end
    
    if BW/2+CA>fs
        disp('Warning. Aliasing will be produced since BW/2+CA < fs');
    end
    
    b = -BW/2 + CA;
    a = (BW/2 + CA - b)/(2*T);
    t = 0:1/fs:T;
    y = conj(exp(1i*2*pi*(a*t.^2+b*t+phi/(2*pi))));
end