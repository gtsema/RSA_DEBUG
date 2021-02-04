function dataFilePath = getFile(path)
    [file, path] = uigetfile('*.bin; *.mat', 'Select data file', path);
    assert(class(file) == "char", 'Файл не выбран');
    dataFilePath = strcat(path, file);
end