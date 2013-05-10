    %Function to advance the pointer in memdata to a specific point in file
    function pointer = lookForString(dataToMem,stringToSearch,pointerIn)
        pointer = pointerIn;
        while (strcmpi(char(dataToMem(pointer:pointer+length(stringToSearch)-1)'),stringToSearch) == false) && pointer < length(dataToMem)-3
           pointer = pointer+1; 
%            char(dataToMem(pointer:length(stringToSearch)-1))
        end
    end