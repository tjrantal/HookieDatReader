    %Function to read data packet
    function packet = readPacket(dataToMem)
        global pointer;
         Key = char(dataToMem(pointer:pointer+1)');
         if   strcmpi(Key,[char(uint8(hex2dec('AA'))), char(uint8(hex2dec('AA')))]) == false 
            disp('Key is not AA AA read failed');
            keyboard;
         end
        i = 2;
        day =  char(dec2hex(dataToMem(pointer+i))); i = i+1;
        month =  char(dec2hex(dataToMem(pointer+i))); i = i+1;
        year =  char(dec2hex(dataToMem(pointer+i))); i = i+1;
        hour =  char(dec2hex(dataToMem(pointer+i))); i = i+1;
        min =  char(dec2hex(dataToMem(pointer+i))); i = i+1;
        sec =  char(dec2hex(dataToMem(pointer+i))); i = i+1;
        if (str2num(month) < 10)
           month = ['0' month]; 
        end
        if (str2num(day) < 10)
           day = ['0' day]; 
        end
        if (str2num(hour) < 10)
           hour = ['0' hour]; 
        end
        if (str2num(min) < 10)
           min = ['0' min]; 
        end
        if (str2num(sec) < 10)
           sec = ['0' sec]; 
        end
        dateVector = [2000+str2num(year) str2num(month) str2num(day) str2num(hour) str2num(min) str2num(sec)];
        timeStamp = datenum(dateVector);    %Get timestamp in matlab compatible format -> datestr(timeStamp returns the date
        %Read the acceleration values from the packet as 16 bit unsigned
        %integers
        packetShortValues = typecast(uint8(dataToMem(pointer+i:pointer+i+503)),'uint16');
        chanIndices = 1:3:length(packetShortValues);
        tempData = zeros(3,length(packetShortValues)/3);
        data = zeros(4,length(packetShortValues)/3);
        data(1,:) = timeStamp;
        for i = 1:3
            tempData(i,:) = packetShortValues(chanIndices+(i-1));
            negativeValueIndices = find(bitand(hex2dec('F000'),tempData(i,:)) >0);
            data(i+1,:) = int16(bitand(hex2dec('0FFF'),tempData(i,:)));    %Interpret all values as positive
            data(i+1,negativeValueIndices) = int16(-hex2dec('1000'))+int16(bitand(hex2dec('0FFF'),tempData(i,negativeValueIndices)));    %fix the interpretation of the negative values
        end
% %         tesindex = find(bitand(hex2dec('F000'),packetShortValues) >0);
% %         testaus = [];
% %         tesindex = [];
% %         keyboard
% %         %Get the values
% %         data = zeros(4,length(packetShortValues)/3);
% %         for i = 1:(length(packetShortValues)/3)
% %             data(1,i) = timeStamp;
% %             data(2,i) = getValue(packetShortValues(3*i-2));  %X
% %             data(3,i) = getValue(packetShortValues(3*i-1));  %Y
% %             data(4,i) = getValue(packetShortValues(3*i));  %Z            
% %         end
% % %          keyboard
        packet = struct();
        packet.data = data;
        packet.timeStamp = timeStamp;
%         keyboard
    end
    
