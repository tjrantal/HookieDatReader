    %Function to extract data from .dat-file header
    function header = readHeader(dataToMem)
        global pointer;
        header = struct();
        %Read measurement date
        stringToLookFor = 'date';
        pointer = lookForString(dataToMem,stringToLookFor,pointer);
        if pointer < length(dataToMem)-3
            header.date = char(dataToMem(pointer+length(stringToLookFor)+2:pointer+length(stringToLookFor)+2+9)');
            pointer = pointer+length(stringToLookFor)+2+9;
            %Get measurement time
            stringToLookFor = 'time';
            pointer = lookForString(dataToMem,stringToLookFor,pointer);
            header.time = char(dataToMem(pointer+length(stringToLookFor)+2:pointer+length(stringToLookFor)+2+7)');
            pointer = pointer+length(stringToLookFor)+2+7;
            %Get sampling rate
            stringToLookFor = 'data rate';
            pointer = lookForString(dataToMem,stringToLookFor,pointer);
            header.samplingRate = char(dataToMem(pointer+length(stringToLookFor)+2:pointer+length(stringToLookFor)+2+5)');
            pointer = pointer+length(stringToLookFor)+2+5;
            %Get compression
            stringToLookFor = 'data compression';
            pointer = lookForString(dataToMem,stringToLookFor,pointer);
            header.compression = char(dataToMem(pointer+length(stringToLookFor)+2:pointer+length(stringToLookFor)+2+2)');
            pointer = pointer+length(stringToLookFor)+2+2;
        else
            pointer = 1;
        end
        %Set the pointer to the beginning of the first data packet
        stringToLookFor = [char(uint8(hex2dec('AA'))), char(uint8(hex2dec('AA')))];
        pointer = lookForString(dataToMem,stringToLookFor,pointer);
    end