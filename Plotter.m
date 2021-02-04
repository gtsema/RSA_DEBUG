classdef Plotter
    methods (Static)
        function plotBin(rawData, shiftedData, decimateData, rangeCompressedData, header, stopTime)
            if (stopTime == 0)
                stopTime = ceil(header.samples/constants.FREQ*1e6);
                pointsNum = header.samples;
                pointsNumDecimate = size(decimateData, 2);
            else
                pointsNum = ceil(stopTime/1e6*constants.FREQ);
                rangeDecimationFactor = floor(constants.FREQ / header.deviation);
                pointsNumDecimate = ceil(stopTime/1e6*(constants.FREQ/rangeDecimationFactor));
            end
            
            figure;
            subplot(4, 1, 1);
            t = linspace(0, stopTime, pointsNum);
            plot(t, rawData(1:pointsNum));
            title('raw');
            xlabel('μs');
            
            subplot(4, 1, 2);
            plot(t, real(shiftedData(1:pointsNum)));
            title('shift');
            xlabel('μs');
            
            subplot(4, 1, 3);
            t = linspace(0, stopTime, pointsNumDecimate);
            plot(t, real(decimateData(1:pointsNumDecimate)));
            title('decimate');
            xlabel('μs');
            
            subplot(4, 1, 4);
            plot(t, abs(rangeCompressedData(1:pointsNumDecimate)));
            title('range compressed');
            xlabel('μs');
        end
        
        function plotMat(decimateData, rangeCompressedData, header, stopTime)
            if (stopTime == 0)
                stopTime = ceil(header.samples/constants.FREQ*1e6);
                pointsNumDecimate = size(decimateData, 2);
            else
                rangeDecimationFactor = floor(constants.FREQ / header.deviation);
                pointsNumDecimate = ceil(stopTime/1e6*(constants.FREQ/rangeDecimationFactor));
            end
            
            figure;
            subplot(2, 1, 1);
            t = linspace(0, stopTime, pointsNumDecimate);
            plot(t, real(decimateData(1:pointsNumDecimate)));
            title('decimate');
            xlabel('μs');
            
            subplot(2, 1, 2);
            plot(t, abs(rangeCompressedData(1:pointsNumDecimate)));
            title('range compressed');
            xlabel('μs');
        end

        function plot(raw, points) 
            if ~exist('points', 'var')
                points = size(raw, 2);
            end
            figure;
            plot(raw(1:points));
        end
    end
end