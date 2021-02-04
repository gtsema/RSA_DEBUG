classdef Header
    properties(Constant)
        HEADER_LEN = 1024
        CYCLE_HEADER_LEN = 128
    end
    properties
        datafile
        header
        
        duration
        period
        size
        frequency
        deviation
        apmplitude
        gate_delay
        gate_duration
        blank_time
        shift
        start_delay
        base
        start
        stop
        decimation
        channels

        samples
    end
    
    methods
        function obj = Header(datafile)
            obj.datafile = datafile;
            obj = readHeader(obj);
            obj = parseHeader(obj);
        end
        
        function headerFilePath = getHeaderFilePath(obj)
            [path, fname, ext] = fileparts(obj.datafile);
            if(lower(ext) == ".bin")
                headerFilePath = strcat(path, '\', fname, '\header.txt');
            elseif(lower(ext) == ".mat")
                headerFilePath = strcat(path, '\header.txt');
            end
        end
        
        function saveToFile(obj, path)
            fid = fopen(strcat(path, '\header.txt'), 'w');
            fprintf(fid, '%s\n', obj.header);
            fclose(fid);
        end
        
        function obj = readHeader(obj)
            [~, ~, ext] = fileparts(obj.datafile);
            if(lower(ext) == ".mat")
                headerFilePath = getHeaderFilePath(obj);
                assert(isfile(headerFilePath), 'Файл header.txt не найден!');
                fid = fopen(headerFilePath);
                data = string(fscanf(fid, '%c'));
                obj.header = strsplit(data,'\n');
            elseif(lower(ext) == ".bin")
                fid = fopen(obj.datafile);
                header_data = fread(fid, [1 obj.HEADER_LEN], 'ubit8=>char');
                str_header = string(header_data);
                obj.header = strsplit(str_header,'\n');
            end
            fclose(fid);   
        end
        
        function obj = parseHeader(obj)
            obj.duration = 1e-6 * str2double(regexp(obj.header(2), '[\d.]+', 'match'));
            obj.period = 1e6 / str2double(cell2mat(regexp(obj.header(3), '\d+', 'match')));
            obj.size = str2double(cell2mat(regexp(obj.header(4), '\d+', 'match')));
            obj.frequency = 1e6 * str2double(cell2mat(regexp(obj.header(5), '\d+', 'match')));
            obj.deviation = 1e6 * str2double(cell2mat(regexp(obj.header(6), '\d+', 'match')));
            obj.apmplitude = str2double(cell2mat(regexp(obj.header(7), '\d+', 'match')));
            obj.gate_delay = str2double(cell2mat(regexp(obj.header(8), '\d+', 'match')));
            obj.gate_duration = str2double(cell2mat(regexp(obj.header(9), '\d+', 'match')));
            obj.blank_time = str2double(cell2mat(regexp(obj.header(10), '\d+', 'match')));
            obj.shift = str2double(cell2mat(regexp(obj.header(11), '\d+', 'match')));
            obj.start_delay = str2double(cell2mat(regexp(obj.header(12), '\d+', 'match')));
            obj.base = str2double(cell2mat(regexp(obj.header(13), '\d+', 'match')));
            obj.start = str2double(cell2mat(regexp(obj.header(14), '\d+', 'match')));
            obj.stop = str2double(cell2mat(regexp(obj.header(15), '\d+', 'match')));
            obj.decimation = str2double(cell2mat(regexp(obj.header(16), '\d+', 'match')));
            obj.channels = str2double(cell2mat(regexp(obj.header(17), '\d+', 'match')));
            
            obj.samples = obj.base + obj.stop;
        end
    end
end