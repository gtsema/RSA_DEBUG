clear all
close all
clc
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~>SETTINGS<~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
path = 'D:\RSA\DATA\testData\2k\2k_003\2k003';

tChannel = channels.FIRST;  % transfer channel (only for Channel=3 mode)
rChannel = channels.FIRST;  % reception channel (for Channel=3 and
                            %                        Channel=2 modes)
chirpNumber = 100;          % number of chirp
stopTime = 0;               % μs
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
dataFilePath = getFile(path);
header = Header(dataFilePath);

[~, ~, ext] = fileparts(dataFilePath);
if(lower(ext) == ".bin" && isnan(header.channels))
    rawData = parse1k(dataFilePath, header, chirpNumber);
    shiftedData = sarShift(rawData, header);
    decimateData = decimation(shiftedData, header);
    rangeCompressedData = rangeCompression(decimateData, header);
    Plotter.plotBin(rawData, shiftedData, decimateData, rangeCompressedData, header, stopTime);
elseif(lower(ext) == ".bin" && ~isnan(header.channels))
    rawData = parse2k(dataFilePath, header, chirpNumber, rChannel, tChannel);
    shiftedData = sarShift(rawData, header);
    decimateData = decimation(shiftedData, header);
    rangeCompressedData = rangeCompression(decimateData, header);
    Plotter.plotBin(rawData, shiftedData, decimateData, rangeCompressedData, header, stopTime);
elseif(lower(ext) == ".mat")
    decimateData = parseMat(dataFilePath, chirpNumber);
    rangeCompressedData = rangeCompression(decimateData, header);
    Plotter.plotMat(decimateData, rangeCompressedData, header, stopTime);
end
 
